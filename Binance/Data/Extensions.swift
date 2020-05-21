//
//  Extensions.swift
//  Binance
//
//  Created by LH on 5/16/20.
//  Copyright © 2020 LH. All rights reserved.
//

import Foundation

extension BANumber {
    var toPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let s = formatter.string(from: NSNumber(value: self*10000))
        return s ?? ""
    }

    var toQuantity: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let s = formatter.string(from: NSNumber(value: self))
        return s ?? ""
    }
}

func print(_ items: Any...) {
    #if DEBUG
        items.forEach {
            Swift.print($0, separator: " ", terminator: "\n")
        }
    #endif
}
