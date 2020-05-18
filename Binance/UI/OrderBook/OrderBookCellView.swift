//
//  OrderbookCellView.swift
//  Binance
//
//  Created by LH on 5/15/20.
//  Copyright © 2020 LH. All rights reserved.
//

import SwiftUI

struct OrderBookCellView: View {
    var bid: BAOrder
    var ask: BAOrder
    let maxNum: BANumber = 1.0

    var body: some View {
        GeometryReader { metrics in
            HStack(spacing: 2) {
                OrderBookBidCellView(bid: self.bid, maxNum: self.maxNum).frame(width: metrics.size.width / 2)
                OrderBookAskCellView(ask: self.ask, maxNum: self.maxNum).frame(width: metrics.size.width / 2)
            }
        }
    }
}

struct OrderBookCellView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookCellView(bid: BAOrder(2.796712, 9641.99), ask: BAOrder(2.157879, 9642.00))
    }
}
