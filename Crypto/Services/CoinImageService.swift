//
//  CoinImageService.swift
//  Crypto
//
//  Created by Lokesh on 30/01/22.
//

import Foundation
import SwiftUI
import Combine
class CoinImageService{
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let coin: Coin
    
    init(coin: Coin){
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName){
            image = savedImage
        } else{
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL.init(string: coin.image)
        else{return}
        
        imageSubscription = NetworkingManager.makeApiCall(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else {return}
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.coin.id, folderName: self.folderName)
            })
    }
}
