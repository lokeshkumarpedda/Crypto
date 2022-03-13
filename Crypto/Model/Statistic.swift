//
//  StatisticsModel.swift
//  Crypto
//
//  Created by Lokesh on 08/02/22.
//

import Foundation

struct Statistic: Identifiable{
    
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil){
        self.title  = title
        self.value = value
        self.percentageChange = percentageChange
    }
}

let gStatistic1 = Statistic(title: "Market Cap", value: "$12.5Bn", percentageChange: -25.34)
let gStatistic2 = Statistic(title: "Total value", value: "$1.5Tr")
