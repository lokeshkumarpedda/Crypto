//
//  ChartView.swift
//  Crypto
//
//  Created by Lokesh on 11/03/22.
//

import SwiftUI

struct ChartView: View {
    let data: [Double]
    let maxY: Double
    let minY: Double
    let lineColor : Color
    let startingDate: Date
    let endingData: Date
    
    @State var percentage: CGFloat = 0
    
    init(_ coin: Coin?){
        self.data = coin?.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        self.lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingData = Date(coinGeckoString: coin?.lastUpdated ?? "")
        startingDate = endingData.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack{
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartYaxis
                            .padding(.horizontal, 4), alignment: .leading)
            HStack{
                Text(startingDate.asShortDateString())
                Spacer()
                Text(endingData.asShortDateString())
            }
            .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                withAnimation(.linear(duration: 2)) {
                    
                    self.percentage = 1
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(gCoin)
    }
}

extension ChartView{
    
    private var chartView: some View{
        GeometryReader{ geometry in
            HStack {
                Path{ path in
                    for index in data.indices{
                        
                        ///  300/100  = 3 * 1 = 4, 3*2 = 6
                        let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                        
                        let yAxis = maxY - minY
                        // why 1 - is if point is 20% then its drawing from top to 20 from below its 80%
                        let yPosition = (1 - CGFloat((data[index] - minY)/yAxis)) * geometry.size.height
                        
                        if index == 0{
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        }
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
                .trim(from: 0, to: percentage)
                .stroke(lineColor ,style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .shadow(color: lineColor, radius: 10, x: 0, y: 10)
                .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
                .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
                .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
            }
        }
    }
    
    private var chartBackground: some View{
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYaxis: some View{
        VStack{
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY)/2).formattedWithAbbreviations())
            Spacer()
            Text(maxY.formattedWithAbbreviations())
        }
    }
    
}
