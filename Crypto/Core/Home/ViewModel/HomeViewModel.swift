//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Lokesh on 30/01/22.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject{
    @Published var statistics: [Statistic] = []
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins = [Coin]()
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption{
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        ///If simple api then we need this, otherwise search text observer will be updating the data
//        dataService.$allCoins.sink {[weak self] returnedCoins in
//            self?.allCoins = returnedCoins
//        }
//        .store(in: &cancellables)
        
        
        ///Can we do it in reverse ? coins.combine with search text ?
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // typing fast in search text, it will wait 0.5 sec to execute below code, eventhough it got multiple listener callbacks
            .map { (text, startingCoins, sort) -> [Coin] in
                let filteredCoins = self.filterCoins(text, coins: startingCoins)
                return self.sortCoins(self.sortOption, coins: filteredCoins)
            }
            .sink {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        portfolioDataService.$savedEntities
            .combineLatest($allCoins)
            .map { (portfolioList, coins) -> [Coin] in
                coins.compactMap { (coin) -> Coin? in
                    if let entity = portfolioList.first(where: {$0.coinId == coin.id}){
                        return coin.updateHoldings(amount: entity.amount)
                    } else{
                        return nil
                    }
                }
            }
            .sink {[weak self] returnedCoins in
                guard let self = self else{return}
                self.portfolioCoins = self.sortPortfolioCoins(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)///Portfolio value should be up to date with my current holdings
            .map { (marketData, portfolioCoins) -> [Statistic] in
                var statistics = [Statistic]()
                guard let data = marketData else{return statistics}
                let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume = Statistic(title: "24h Volume", value: data.volume)
                let bitcoinDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
                
                let portfolioValue = portfolioCoins.map ({ $0.currentHoldingsValue})
                                                    .reduce(0, +)
                let previousValue = portfolioCoins.map { coin -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
                    let previousValue = currentValue/(1 + percentageChange)
                    return previousValue
                }
                    .reduce(0, +)
                let percentageChange = ((portfolioValue - previousValue) / previousValue)
                let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
                
                statistics.append(contentsOf: [marketCap,volume, bitcoinDominance, portfolio])
                return statistics
            }
            .sink {[weak self] stats in
                self?.statistics = stats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: Coin, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterCoins(_ text: String, coins: [Coin]) -> [Coin]{
        guard !text.isEmpty else{
            return coins
        }
        let lowerCasedText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowerCasedText) ||
            coin.symbol.lowercased().contains(lowerCasedText) ||
            coin.id.lowercased().contains(lowerCasedText)
        }
    }
    
    private func sortCoins(_ sort: SortOption, coins: [Coin]) -> [Coin]{
        switch sort {
        case .rank, .holdings:
            return coins.sorted(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
            return coins.sorted(by: {$0.rank > $1.rank})
        case .price:
            return coins.sorted(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed:
            return coins.sorted(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoins(coins: [Coin]) -> [Coin]{
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
}
