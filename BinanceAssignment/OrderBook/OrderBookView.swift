//
//  OrderBookView.swift
//  BinanceAssignment
//
//  Created by LH on 5/15/20.
//  Copyright © 2020 LH. All rights reserved.
//

import SwiftUI

struct OrderBookView: View {
    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }
    
    let data = (0..<50).map {
        OrderBook(
            id: $0,
            ask: (BANumber.random(in: 0.1..<3), BANumber.random(in: 9000..<9999)),
            bid: (BANumber.random(in: 0.1..<3), BANumber.random(in: 9000..<9999)))
    }
    
    
    var body: some View {
        List(data) { v in
            OrderBookCellView(bid: v.bid, ask: v.ask)
                .padding(.vertical, -6)
        }
        .environment(\.defaultMinListRowHeight, 30)
    }
}


struct OrderBookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookView().colorScheme(.dark)
    }
}
