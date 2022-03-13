//
//  HomeStatisticsView.swift
//  Crypto
//
//  Created by Lokesh on 08/02/22.
//

import SwiftUI

struct HomeStatisticsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack{
            ForEach(vm.statistics){statistic in
                StatisticView(stat: statistic)
                    .frame(width: UIScreen.main.bounds.width/3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ?.trailing : .leading)
    }
}

struct HomeStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatisticsView(showPortfolio: .constant(true))
    }
}
