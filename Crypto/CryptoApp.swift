//
//  CryptoApp.swift
//  Crypto
//
//  Created by Lokesh on 29/01/22.
//

import SwiftUI

//Ref
/*
 For api: https://www.coingecko.com/en/api/documentation
 model conversion: https://app.quicktype.io/
 */
@main
struct CryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView = true
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                NavigationView{
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(vm)
                
                ZStack{
                    if showLaunchView{
                        LaunchView(showLaunchScreen: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2)
            }
        }
    }
}
