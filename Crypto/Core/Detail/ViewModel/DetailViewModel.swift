//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Lokesh on 11/03/22.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject{
    @Published var overviewStatistics: [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    @Published var coin: Coin? = nil
    
    private var coinDetailDataService: CoinDetailDataService? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin?){
        self.coin = coin
        if let coin = coin {
            self.coinDetailDataService = CoinDetailDataService(coin)
        }
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        coinDetailDataService?.$coinDetail
            .combineLatest($coin)
            .map(mapToStatics)
            .sink(receiveValue: {[weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            })
            .store(in: &cancellables)
        
        coinDetailDataService?.$coinDetail
            .sink(receiveValue: {[weak self] returnedCoinDetails in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            })
            .store(in: &cancellables)
    }
    
    
    private func mapToStatics(coinDetail: CoinDetail?, coin: Coin?) -> (overview: [Statistic], additional: [Statistic]){
        guard let coin = coin else {
            return ([], [])
        }
        
        //Overview
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let priceStat = Statistic(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volume", value: volume)
        
        let overviewArray = [priceStat, marketCapStat, rankStat, volumeStat]
        
        //Additional
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = Statistic(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = Statistic(title: "24h Low", value: low)
        
        let priceChange = coin.priceChangePercentage24H?.asCurrencyWith2Decimals() ?? "n/a"
        let pricePercentChange2 = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeInString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = Statistic(title: "Block Time", value: blockTimeInString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray = [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat]
        return (overviewArray, additionalArray)
    }
}
