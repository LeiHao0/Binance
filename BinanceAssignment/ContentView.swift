//
//  ContentView.swift
//  BinanceAssignment
//
//  Created by LH on 5/14/20.
//  Copyright © 2020 LH. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var favoriteColor = 0
    
    var body: some View {
        VStack {
            Picker(selection: $favoriteColor, label: Text("What is your favorite color?")) {
                Text("Order Book").tag(0)
                Text("Market Histroy").tag(1)
                Text("Info").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
            HStack {
                HStack {
                    Text("Bid")
                        .font(.footnote)
                        .fontWeight(.light)
                        .foregroundColor(Color.gray)
                    Spacer()
                }
                .padding(.horizontal)
                HStack {
                    Text("Ask")
                        .font(.footnote)
                        .fontWeight(.light)
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            }
            .frame(height: 10.0)
            OrderBookView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
