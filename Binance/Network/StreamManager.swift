//
//  StreamManager.swift
//  Binance
//
//  Created by LH on 5/17/20.
//  Copyright © 2020 LH. All rights reserved.
//

import Foundation
import Starscream
import SwiftyJSON
import Alamofire


let bbType = BBType.bnbbtc

class StreamManager {
    public static let shared = StreamManager()
    
    private let socket: WebSocket
    private let streamWss = "wss://stream.binance.com:9443/ws/\(bbType.rawValue)@depth"
    private let depthSnapshot = "https://www.binance.com/api/v1/depth?symbol=\(bbType.rawValue.uppercased())&limit=1000"
    private var isConnected = false
    private var lastUpdateId = 0
    private init() {
        var request = URLRequest(url: URL(string: streamWss)!)
        request.timeoutInterval = 10
        socket = WebSocket(request: request)
        socket.callbackQueue = DispatchQueue(label: "io.leihao.Binance")
        socket.delegate = self
    }
    
    public func start() {
        AF.request(depthSnapshot, method: .get).validate().responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                if let id = JSON(value)["lastUpdateId"].int, let self = self {
                    self.lastUpdateId = id
                    self.socket.connect()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func stop() {
        socket.disconnect()
    }
    
    
}

extension StreamManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
//            print("Received text: \(string)")
            filterData(string)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            // Starscream will automatically respond to incoming ping control frames so you do not need to manually send pongs.
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    private func handleError(_ e: Error?) {
        print(e ?? "")
    }
    
    private func filterData(_ string: String) {
        
        guard var sp = try? JSONDecoder().decode(StreamPack.self, from: Data(string.utf8)) else {
            print("Received text toJson failed: ", string)
            return
        }
        guard sp.u > self.lastUpdateId else {
            print("Received StreamPack: Drop u(\(sp.u)) <= lastUpdateId(\(lastUpdateId) in the snapshot.")
            return
        }
        
        
        sp.a = sp.a.filter { BANumber($0[1]) != 0 }
        sp.b = sp.b.filter { BANumber($0[1]) != 0 }
        
        print("Received StreamPack:", sp)
        
        
    }
    
}
