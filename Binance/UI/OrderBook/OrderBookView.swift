//
//  OrderBookView.swift
//  Binance
//
//  Created by LH on 5/15/20.
//  Copyright © 2020 LH. All rights reserved.
//

import SwiftUI

struct OrderBookView: View {
    static let every: TimeInterval = 10
    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
        StreamManager.shared.start()
    }

    @EnvironmentObject var orderBooksPublisher: OrderBooksPublisher

    var body: some View {
        
        ZStack {
            List(orderBooksPublisher.orderBooks) { v in
                OrderBookCellView(bid: v.bid, ask: v.ask)
                    .padding(.vertical, -6)
                    .animation(nil)
            }
                //        .id(UUID())
                // What a kind of fix SwiftUI...
                .animation(nil)
                .environment(\.defaultMinListRowHeight, 30)
            if (orderBooksPublisher.orderBooks.isEmpty) {
                LoadingView()
            }
        }
    }
}

struct OrderBookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookView().colorScheme(.dark).environmentObject(orderBooksPublisher)
    }
}
