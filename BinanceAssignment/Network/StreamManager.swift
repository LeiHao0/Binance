//
//  StreamManager.swift
//  BinanceAssignment
//
//  Created by LH on 5/17/20.
//  Copyright © 2020 LH. All rights reserved.
//

import Foundation
import Starscream

class StreamManager {
    public static let shared = StreamManager()
    
    public func connect() {
        
    }
    
    let socket: WebSocket
    
    private var isConnected = false
    private init() {
        var request = URLRequest(url: URL(string: "wss://stream.binance.com:9443/ws/bnbbtc@depth")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
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
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
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
    
}
