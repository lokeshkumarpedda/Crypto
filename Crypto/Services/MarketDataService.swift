//
//  MarketDataService.swift
//  Crypto
//
//  Created by Lokesh on 03/03/22.
//

import Foundation
import Combine

class MarketDataService{
    
    @Published var marketData:MarketData? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    init(){
        getData()
    }
    
    func getData(){
        
        guard let url = URL.init(string: "https://api.coingecko.com/api/v3/global")
        else{return}
        
        marketDataSubscription = NetworkingManager.makeApiCall(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] globalDate in
                self?.marketData = globalDate.data
                self?.marketDataSubscription?.cancel()
            })
//            .sink { completion in
//                NetworkingManager.handleCompletion(completion)
//            } receiveValue: {[weak self] returnedCoins in
//                self?.allCoins = returnedCoins
//                self?.coinSubscription?.cancel()
//            }

    }
}
