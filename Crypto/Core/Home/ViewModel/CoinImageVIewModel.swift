//
//  CoinImageVIewModel.swift
//  Crypto
//
//  Created by Lokesh on 30/01/22.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject{
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = true
    
    private let coin: Coin
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin){
        self.coin = coin
        dataService = CoinImageService(coin: coin)
        getImage()
    }
    
    private func getImage(){
        dataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: {[weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
