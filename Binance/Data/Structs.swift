//
//  Structs.swift
//  Binance
//
//  Created by LH on 5/15/20.
//  Copyright © 2020 LH. All rights reserved.
//

import Foundation
import SwiftyJSON

enum BBType: String {
    case btcusdt, bnbbtc
}

enum OrderType {
    case bid, ask
}

typealias BANumber = Double

struct BAOrder {
    var price, quantity: BANumber
    init(_ price: String, _ quantity: String) {
        self.price = BANumber(price) ?? 0
        self.quantity = BANumber(quantity) ?? 0
    }

    init(_ price: BANumber, _ quantity: BANumber) {
        self.price = price
        self.quantity = quantity
    }
}

struct OrderBook: Identifiable {
    var id: Int
    var ask: BAOrder
    var bid: BAOrder
}

struct StreamPack: Codable {
    let e: String
    let E: Int
    let u, U: Int
    let s: String
    var b: [[String]]
    var a: [[String]]
}

/// ---

func mockOrder(_ id: Int, ask: BAOrder? = nil, bid: BAOrder? = nil) -> OrderBook {
    OrderBook(
        id: id,
        ask: ask ?? BAOrder(BANumber.random(in: 0.1 ..< 3), BANumber.random(in: 9000 ..< 9999)),
        bid: bid ?? BAOrder(BANumber.random(in: 0.1 ..< 3), BANumber.random(in: 9000 ..< 9999))
    )
}
