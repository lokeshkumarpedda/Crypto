//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Lokesh on 07/03/22.
//

import Foundation
import CoreData
import UIKit

class PortfolioDataService{
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
 
    init(){
        self.container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error{
                print("Error loading coredata: \(error)")
            }
        }
        self.getPortfolio()
    }
    
    //MARK: PUBLIC
    func updatePortfolio(coin: Coin, amount: Double){
        if let entity = savedEntities.first(where: {$0.coinId == coin.id}){
            if amount > 0{
                update(entity: entity, amount: amount)
            }else{
                delete(entity: entity)
            }
        }else{
            add(coin: coin, amount: amount)
        }
    }
    
    
    
    //MARK: PRIVATE
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do{
            savedEntities = try container.viewContext.fetch(request)
        }catch let error{
            print("Error fetching portfolio entities \(error)")
        }
    }
    
    private func add(coin: Coin, amount: Double){
        let portfolio = PortfolioEntity(context: container.viewContext)
        portfolio.coinId = coin.id
        portfolio.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        do{
            try container.viewContext.save()
        }catch let error{
            print("Error saving coredata \(error)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
    
}
