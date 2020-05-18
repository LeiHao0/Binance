//
//  StreamManager.swift
//  Binance
//
//  Created by LH on 5/17/20.
//  Copyright © 2020 LH. All rights reserved.
//

import Alamofire
import Foundation
import Starscream
import SwiftyJSON

let orderBooksPublisher = OrderBooksPublisher()
class OrderBooksPublisher: ObservableObject {
    @Published var orderBooks = [OrderBook]()
}

class StreamManager {
    public static let shared = StreamManager()
    public func start() {
        socket.connect()
        getLastUpdateId()
    }

    public func stop() {
        socket.disconnect()
        clearBuffer()
        retryTimes = 0
    }

    public func restart() {
        stop()
        start()
    }

    private static let bbType = BBType.bnbbtc
    private let socket: WebSocket
    private let streamWss = "wss://stream.binance.com:9443/ws/\(bbType.rawValue)@depth"
    private let depthSnapshot = "https://www.binance.com/api/v1/depth?symbol=\(bbType.rawValue.uppercased())&limit=1000"
    private var isConnected = false
    private var lastUpdateId = 0

    private var retryTimes = 0

    private var shouldBroadcast = false

    private let queue = DispatchQueue(label: "io.leihao.Binance")

    private init() {
        var request = URLRequest(url: URL(string: streamWss)!)
        request.timeoutInterval = 10
        socket = WebSocket(request: request)
        socket.callbackQueue = queue
        socket.delegate = self
    }

    private func getLastUpdateId() {
        func retry() {
            retryTimes += 1
            if retryTimes < 3 { getLastUpdateId() }
        }

        AF.request(depthSnapshot, method: .get).validate().responseJSON { [weak self] response in
            switch response.result {
            case let .success(value):
                guard let id = JSON(value)["lastUpdateId"].int, let self = self else { retry(); return }
                self.lastUpdateId = id
                self.queue.asyncAfter(deadline: .now() + Double(self.streamPacksBufferSize) - 1.5) { [weak self] in
                    self?.updateStreamPacksBuffer()
                }
            case let .failure(error):
                retry()
                print(error)
            }
        }
    }

    /// StreamPacksBuffer

    private let streamPacksBufferSize = 3
    private var streamPacksBuffer = [StreamPack]()
    private func clearBuffer() {
        streamPacksBuffer = []
    }

    private let lock = NSLock()
    private func updateStreamPacksBuffer() {
        defer { lock.unlock() }

        lock.lock()

        // 4. Drop any event where `u` is <= `lastUpdateId` in the snapshot.
        streamPacksBuffer = streamPacksBuffer.filter { $0.u > lastUpdateId }

        // 5. The first processed event should have `U` <= `lastUpdateId`+1 **AND** `u` >= `lastUpdateId`+1.
        if let sp = streamPacksBuffer.first, sp.U < lastUpdateId, lastUpdateId < sp.u {
            streamPacksBuffer.append(sp)
            shouldBroadcast = true
        } else {
            print("Received StreamPack: buffer is empty or lastUpdateId:\(lastUpdateId) not in range U...u, retry getLastUpdateId")
            getLastUpdateId()
        }
    }

    private func broadcastOrderBooks() {
        if shouldBroadcast {
            let ab = streamPacksBuffer.reduce(([BAOrder](), [BAOrder]())) {
                ($0.0 + $1.a.map { BAOrder($0[0], $0[1]) },
                 $0.1 + $1.b.map { BAOrder($0[0], $0[1]) })
            }

            var orderBooks = [OrderBook]()
            var i = 0, j = 0
            while i < ab.0.count, j < ab.1.count {
                orderBooks.append(OrderBook(id: i, ask: ab.0[i], bid: ab.1[j]))
                i += 1; j += 1
            }
            while i < ab.0.count {
                orderBooks.append(OrderBook(id: i, ask: ab.0[i], bid: BAOrder(0, 0)))
                i += 1
            }
            while j < ab.1.count {
                orderBooks.append(OrderBook(id: i, ask: BAOrder(0, 0), bid: ab.1[j]))
                j += 1
            }

//            let ob = (0 ..< 30).map { mockOrder($0) }
            DispatchQueue.main.async {
                orderBooksPublisher.orderBooks = orderBooks
            }
        }
    }

    private func append(_ sp: StreamPack) {
        if streamPacksBuffer.count > streamPacksBufferSize {
            streamPacksBuffer.remove(at: 0)
        }
        streamPacksBuffer.append(sp)

        broadcastOrderBooks()
    }
}

extension StreamManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client _: WebSocket) {
        switch event {
        case let .connected(headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case let .disconnected(reason, code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case let .text(string):
//            print("Received text: \(string)")
            appendData(string)
        case let .binary(data):
            print("Received data: \(data.count)")
        case .ping:
            // Starscream will automatically respond to incoming ping control frames so you do not need to manually send pongs.
            break
        case .pong:
            break
        case .viabilityChanged:
            break
        case .reconnectSuggested:
            break
        case .cancelled:
            isConnected = false
        case let .error(error):
            isConnected = false
            handleError(error)
        }
    }

    private func handleError(_ e: Error?) {
        print(e ?? "")
    }

    private func appendData(_ string: String) {
        guard var sp = try? JSONDecoder().decode(StreamPack.self, from: Data(string.utf8)) else {
            print("Received text toJson failed: ", string)
            return
        }
//        print("Received StreamPack:", sp)
        print("id: \(lastUpdateId) U:\(sp.U) u:\(sp.u)")

        // 6. While listening to the stream, each new event's `U` should be equal to the previous event's `u`+1.
        if let u = streamPacksBuffer.last?.u, u + 1 == sp.U {
            // 8. If the quantity is 0, **remove** the price level.
            sp.a = sp.a.filter { BANumber($0[1]) != 0 }
            sp.b = sp.b.filter { BANumber($0[1]) != 0 }
        } else {
            clearBuffer()
        }
        append(sp)
    }
}
