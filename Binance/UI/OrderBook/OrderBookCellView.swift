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
    let maxNum: BANumber = 20000.0

    var body: some View {
        HStack(spacing: 2) {
            ZStack {
                OrderBookBgColor(type: .bid, percentage: CGFloat(bid.price * bid.quantity / maxNum))
                HStack(spacing: 0) {
                    OrderBookCellText(text: bid.price.toQuantity)
                    Spacer()
                    OrderBookCellText(text: bid.quantity.toPrice)
                        .foregroundColor(Color.green)
                    Spacer().frame(width: 2)
                }
            }.clipped()
            ZStack {
                OrderBookBgColor(type: .ask, percentage: CGFloat(ask.price * ask.quantity / maxNum))
                HStack(spacing: 0) {
                    Spacer().frame(width: 2)
                    OrderBookCellText(text: ask.quantity.toPrice)
                        .foregroundColor(Color.red)
                    Spacer()
                    OrderBookCellText(text: ask.price.toQuantity)
                }
            }.clipped()
        }
    }
}

struct OrderBookCellView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookCellView(bid: BAOrder(price: 2.796712, quantity: 9641.99), ask: BAOrder(price: 2.157879, quantity: 9642.00))
    }
}
