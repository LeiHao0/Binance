//
//  Structs.swift
//  Binance
//
//  Created by LH on 5/15/20.
//  Copyright © 2020 LH. All rights reserved.
//

import Foundation

enum OrderType {
    case bid, ask
}

typealias BANumber = Double


struct OrderBook: Identifiable {
    var id: Int
    var ask: (BANumber, BANumber)
    var bid: (BANumber, BANumber)
}

struct StreamPack: Codable {
    let e: String
    let E: Int
    let u, U: Int
    let s: String
    let b: [[String]]
    let a: [[String]]
}

/// ---

func mockOrder(_ id: Int, ask: (BANumber, BANumber)? = nil, bid: (BANumber, BANumber)? = nil) -> OrderBook {
    OrderBook(
        id: id,
        ask: ask ?? (BANumber.random(in: 0.1..<3), BANumber.random(in: 9000..<9999)),
        bid: bid ?? (BANumber.random(in: 0.1..<3), BANumber.random(in: 9000..<9999)))
}


