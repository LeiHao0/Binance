//
//  Extensions.swift
//  BinanceAssignment
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
        let s = formatter.string(from: NSNumber(value: self))
        return s ?? ""
    }
    
    var toQuantity: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 6
        let s = formatter.string(from: NSNumber(value: self))
        return s ?? ""
    }
}
