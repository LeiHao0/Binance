//
//  OrderBookComponents.swift
//  BinanceAssignment
//
//  Created by LH on 5/16/20.
//  Copyright © 2020 LH. All rights reserved.
//

import SwiftUI

struct OrderBookCellText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.custom("Helvetica", size: 13))
            .fontWeight(.light)
    }
}
