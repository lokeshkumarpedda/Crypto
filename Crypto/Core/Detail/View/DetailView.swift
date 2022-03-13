//
//  DetailView.swift
//  Crypto
//
//  Created by Lokesh on 11/03/22.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var vm: DetailViewModel
    @State private var showFullDescription = false
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(coin: Coin?){
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            VStack{
                ChartView(vm.coin)
                    .padding(.vertical)
                details
            }
        }
        .background(Color.theme.background
                        .ignoresSafeArea())
        .navigationTitle(vm.coin?.name ?? "")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    Text(vm.coin?.symbol.uppercased() ?? "")
                        .font(.headline)
                        .foregroundColor(Color.theme.secondaryText)
                    CoinImageView(coin: vm.coin ?? gCoin)
                        .frame(width: 25, height: 25)
                }
            }
        }
    }
    
    
    private var details: some View{
        VStack(spacing: 20){
            Text("Overview")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            description
            LazyVGrid(columns: columns,
                      alignment: .leading,
                      spacing: 30,
                      pinnedViews: []) {
                ForEach(vm.overviewStatistics){ statistic in
                    StatisticView(stat: statistic)
                }
            }
            
            
            Text("Additional Details")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            
            LazyVGrid(columns: columns,
                      alignment: .leading,
                      spacing: 30,
                      pinnedViews: []) {
                ForEach(vm.additionalStatistics){ statistic in
                    StatisticView(stat: statistic)
                }
            }
            websiteSection
        }
        .padding()
    }
    
    
    private var description: some View{
        ZStack{
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty{
                VStack(alignment: .leading){
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" :"Read more..")
                            .font(.caption)
                            .bold()
                            .padding(.vertical, 4)
                    }
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var websiteSection : some View{
        VStack(alignment: .leading, spacing: 20){
            if let websiteUrl = vm.websiteURL, !websiteUrl.isEmpty, let url = URL(string: websiteUrl){
                Link("Website", destination: url)
            }
            
            if let redditUrl = vm.redditURL, !redditUrl.isEmpty, let url = URL(string: redditUrl){
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: gCoin)
        }
    }
}
