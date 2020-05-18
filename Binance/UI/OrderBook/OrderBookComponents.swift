//
//  OrderBookComponents.swift
//  Binance
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

struct OrderBookBidCellView: View {
    var bid: BAOrder
    let maxNum: BANumber

//    @ViewBuilder
    var body: some View {
        return ZStack {
            OrderBookBgColor(type: .bid, percentage: CGFloat(bid.price * bid.quantity / maxNum))
            HStack(spacing: 0) {
                OrderBookCellText(text: bid.price == 0 ? "" : bid.price.toQuantity)
                Spacer()
                OrderBookCellText(text: bid.quantity == 0 ? "" : bid.quantity.toPrice)
                    .foregroundColor(Color.green)
                Spacer().frame(width: 2)
            }
        }.clipped()
    }
}

struct OrderBookAskCellView: View {
    var ask: BAOrder
    let maxNum: BANumber
    var body: some View {
        ZStack {
            OrderBookBgColor(type: .ask, percentage: CGFloat(ask.price * ask.quantity / maxNum))
            HStack(spacing: 0) {
                Spacer().frame(width: 2)
                OrderBookCellText(text: ask.quantity == 0 ? "" : ask.quantity.toPrice)
                    .foregroundColor(Color.red)
                Spacer()
                OrderBookCellText(text: ask.price == 0 ? "" : ask.price.toQuantity)
            }
        }.clipped()
    }
}
