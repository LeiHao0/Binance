//
//  Structs.swift
//  BinanceAssignment
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
