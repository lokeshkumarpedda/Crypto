//
//  LaunchView.swift
//  Crypto
//
//  Created by Lokesh on 11/03/22.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your portfolio...".map{String($0)}
    @State private var showLoadingText = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    @State private var loops = 0
    @Binding var showLaunchScreen: Bool
    
    var body: some View {
        ZStack(alignment: .center){
            Color.launch.background
                .ignoresSafeArea()
            Text("Crypto")
                .font(.system(size: 35, weight: .bold))
                .foregroundColor(Color.launch.accent)
            
            ZStack{
                if showLoadingText{
//                    Text(loadingText)
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .foregroundColor(Color.launch.accent)
//                        .transition(AnyTransition.scale.animation(.easeIn))
                    HStack(spacing: 0){
                        ForEach(loadingText.indices){index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launch.accent)
                                .offset(y: index == counter ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation {
                if counter == loadingText.count - 1{
                    counter = 0
                    loops += 1
                    if loops > 2{
                        showLaunchScreen = false
                    }
                } else{
                    counter += 1
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchScreen: .constant(true))
    }
}
