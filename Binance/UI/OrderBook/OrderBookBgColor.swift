//
//  BackgroudColorView.swift
//  Binance
//
//  Created by LH on 5/15/20.
//  Copyright © 2020 LH. All rights reserved.
//

import SwiftUI

struct OrderBookBgColor: View {
    var type: OrderType
    var percentage: CGFloat {
        didSet {
            percentage = percentage > 1 ? 1 : percentage
        }
    }
    
    var body: some View {
        GeometryReader { metrics in
            HStack() {
                if self.type == .bid {
                    Spacer()
                    Color("BgGreen").frame(width: metrics.size.width * self.percentage)
                } else {
                    Color("BgRed").frame(width: metrics.size.width * self.percentage)
                    Spacer()
                }
            }.clipped() 
        }
    }
}

struct OrderBookBgColorView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookBgColor(type: .bid, percentage: 0.4)
    }
}
