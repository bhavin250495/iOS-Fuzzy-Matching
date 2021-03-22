//
//  HomeView.swift
//  SearchPOC
//
//  Created by Suthar, Bhavin Udavji on 22/03/21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
                
                NavigationView {
                    
                    VStack {
                        Text("Correction POC")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundColor(Color.black)
                        Spacer()
                        NavigationLink(destination: CorrectionView()) {
                            Text("Correction")
                                .frame(minWidth: 0, maxWidth: 300)
                                .padding()
                                .foregroundColor(.white)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(40)
                                .font(.title)
                        }
                            NavigationLink(destination: ContentView()) {
                                Text("Cosine Similarity")
                                    .frame(minWidth: 0, maxWidth: 300)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(40)
                                    .font(.title)
                        
                       
                        }
                    }
                    
                    
                }
 
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
