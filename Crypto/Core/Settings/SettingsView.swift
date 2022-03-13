//
//  SettingsView.swift
//  Crypto
//
//  Created by Lokesh on 11/03/22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    let defaultUrl = URL(string: "https://www.google.com")!
    let youtubeUrl = URL(string: "https://www.youtube.com")!
    let coinGeckoUrl = URL(string: "https://www.coingecko.com")!
    let personalUrl = URL(string: "https://github.com/lokeshkumarpedda")!
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.theme.background
                    .ignoresSafeArea()
                List{
                    Section {
                        VStack(alignment: .leading, spacing: 20){
                            Image(systemName: "airplane")
                                .font(.title)
                                .foregroundColor(.red)
                            Text("The cryptocurrency data is coming from a free api from CoinGecko! Prices may be slightly delayed.")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(Color.theme.accent)
                        }
                        .padding(.vertical)
                        Link("Visit CoinGecko", destination: coinGeckoUrl)
                    } header: {
                        Text("API")
                    }
                    .listRowBackground(Color.theme.background)
                    
                    Section {
                        VStack(alignment: .leading, spacing: 20){
                            Image(systemName: "airplane")
                                .font(.title)
                                .foregroundColor(.red)
                            Text("This app was developed by Lokesh kumar.")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(Color.theme.accent)
                        }
                        .padding(.vertical)
                        Link("Visit Github page", destination: personalUrl)
                    } header: {
                        Text("Developer")
                    }
                    .listRowBackground(Color.theme.background)
                    
                    Section {
                        Link("Terms of service", destination: defaultUrl)
                        Link("Learn more", destination: personalUrl)
                    } header: {
                        Text("Application")
                    }
                    .listRowBackground(Color.theme.background)
                }
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
