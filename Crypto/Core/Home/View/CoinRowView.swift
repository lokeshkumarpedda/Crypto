//
//  CoinRowView.swift
//  Crypto
//
//  Created by Lokesh on 29/01/22.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
            Spacer()
            if showHoldingsColumn{
                VStack(alignment: .trailing){
                    Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                        .bold()
                    Text((coin.currentHoldings ?? 0).asNumberString())
                }
                .foregroundColor(Color.theme.accent)
            }
            VStack(alignment: .trailing){
                Text(coin.currentPrice.asCurrencyWith6Decimals())
                    .bold()
                    .foregroundColor(Color.theme.accent)
                Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                    .foregroundColor(
                        (coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red
                    )
            }
            .frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing)
        }
        .font(.subheadline)
        .background(Color.theme.background.opacity(0.001))// for clicking the whole row
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
        CoinRowView(coin: gCoin, showHoldingsColumn: true)
            .previewLayout(.sizeThatFits)
        CoinRowView(coin: gCoin, showHoldingsColumn: true)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
    }
}
