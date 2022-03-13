//
//  CoinDetailDataervice.swift
//  Crypto
//
//  Created by Lokesh on 11/03/22.
//

import Foundation
import Combine

class CoinDetailDataService{
    @Published var coinDetail:CoinDetail? = nil
    
    var coinDetailSubscription: AnyCancellable?
    let coin: Coin
    
    init(_ coin: Coin){
        self.coin = coin
        getCoinDetail()
    }
    
    func getCoinDetail(){
        
        guard let url = URL.init(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else{return}
        
        coinDetailSubscription = NetworkingManager.makeApiCall(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoinDetail in
                self?.coinDetail = returnedCoinDetail
                self?.coinDetailSubscription?.cancel()
            })
    }
}
