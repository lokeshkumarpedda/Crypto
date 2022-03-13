//
//  HomeView.swift
//  Crypto
//
//  Created by Lokesh on 29/01/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio = false
    @State private var showAddPortfolioView = false
    @State private var showSettingView = false
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView = false
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showAddPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            VStack{
                homeViewHeader
                
                HomeStatisticsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                if !showPortfolio{
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                if showPortfolio{
                    ZStack(alignment: .top){
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty{
                            Text("You haven't added any coins to your portfolio yet! Click the + button to get started.")
                                .font(.callout)
                                .foregroundColor(Color.theme.accent)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .padding(50)
                        }else{
                            portfolioCoinsList
                                .transition(.move(edge: .trailing))
                        }
                    }
                }
                Spacer()
            }
            .sheet(isPresented: $showSettingView) {
                SettingsView()
            }
        }
        .background(
            NavigationLink(destination: DetailView(coin: selectedCoin),
                           isActive: $showDetailView,
                           label: {EmptyView()})
        )
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

extension HomeView{
    
    private var homeViewHeader: some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
                .onTapGesture {
                    if showPortfolio{
                        showAddPortfolioView.toggle()
                    } else{
                        showSettingView.toggle()
                    }
                }
            Spacer ()
            Text(showPortfolio ? "My Portfolio":"Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.left")
                .rotationEffect(Angle(degrees: showPortfolio ? 0 : 180))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }.padding(.horizontal)
    }
    
    private var columnTitles: some View{
        HStack{
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 :0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation{
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio{
                HStack(spacing: 4){
                    Text("Holding")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 :0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation{
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 :0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation{
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            Button(action: {
                vm.reloadData()
            }, label: {
                Image(systemName: "goforward")
            })
                .rotationEffect(Angle(degrees:vm.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View{
        List{
            ForEach(vm.allCoins) {coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        onCoinTapped(coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList: some View{
        List{
            ForEach(vm.portfolioCoins) {coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        onCoinTapped(coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func onCoinTapped(_ coin: Coin){
        selectedCoin = coin
        showDetailView = true
    }
}
