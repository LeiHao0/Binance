//
//  OrderbookCellView.swift
//  Binance
//
//  Created by LH on 5/15/20.
//  Copyright © 2020 LH. All rights reserved.
//

import SwiftUI

struct OrderBookCellView: View {
    var bid: (BANumber, BANumber)
    var ask: (BANumber, BANumber)
    let maxNum: BANumber = 20000.0
    
    var body: some View {
        HStack(spacing: 2) {
            ZStack {
                OrderBookBgColor(type: .bid, percentage: CGFloat(bid.0*bid.1/maxNum) )
                HStack(spacing: 0) {
                    OrderBookCellText(text: bid.0.toQuantity)
                    Spacer()
                        OrderBookCellText(text: bid.1.toPrice)
                        .foregroundColor(Color.green)
                    Spacer().frame(width: 2)
                }
            }.clipped()
            ZStack {
                OrderBookBgColor(type: .ask, percentage: CGFloat(ask.0*ask.1/maxNum))
                HStack(spacing: 0)  {
                    Spacer().frame(width: 2)
                    OrderBookCellText(text: ask.1.toPrice)
                        .foregroundColor(Color.red)
                    Spacer()
                    OrderBookCellText(text: ask.0.toQuantity)
                }
            }.clipped()
        }
    }
}



struct OrderBookCellView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookCellView(bid: (2.796712, 9641.99), ask: (2.157879, 9642.00))
    }
}
