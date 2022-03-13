//
//  CoinDataService.swift
//  Crypto
//
//  Created by Lokesh on 30/01/22.
//

import Foundation
import Combine

class CoinDataService{
    
    @Published var allCoins:[Coin] = []
    
    var coinSubscription: AnyCancellable?
    
    init(){
        getCoins()
    }
    
    func getCoins(){
        
        guard let url = URL.init(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else{return}
        
        coinSubscription = NetworkingManager.makeApiCall(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
//            .sink { completion in
//                NetworkingManager.handleCompletion(completion)
//            } receiveValue: {[weak self] returnedCoins in
//                self?.allCoins = returnedCoins
//                self?.coinSubscription?.cancel()
//            }

    }
}
