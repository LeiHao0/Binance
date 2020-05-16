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
    
    @State var data: [OrderBook] = (0..<50).map { mockOrder($0) }
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private func updateData() {
        data = data[10...].map {
            mockOrder($0.id-10, ask: $0.ask, bid: $0.bid) }
            + (40..<50).map { mockOrder($0) }
     }
    
    var body: some View {
        List(data) { v in
            OrderBookCellView(bid: v.bid, ask: v.ask)
                .padding(.vertical, -6)
        }.onReceive(timer) { input in
            self.updateData()
        }
        .environment(\.defaultMinListRowHeight, 30)
    }
}


struct OrderBookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookView().colorScheme(.dark)
    }
}
