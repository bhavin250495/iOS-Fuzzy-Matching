//
//  CorrectionView.swift
//  SearchPOC
//
//  Created by Suthar, Bhavin Udavji on 22/03/21.
//

import SwiftUI

struct CorrectionView: View {
    @State private var searchText = ""
    var arrayd = ["Crocin","Paracetamol", "Ibuprofin", "Dicyclomine", "Domperidone","Hydrochlorothiazide",
                  "Amoxicillin", "Hydrocodone"]
    let correctionEngine = CorrectionEngine()
    init() {
        correctionEngine.setup(vocabulary: arrayd)
    }
    
    
    var body: some View {
        HStack {
            
            
            VStack(alignment: .leading, spacing: 10) {
                SearchBar(text: $searchText)
                    .padding(.top, 0.0)
                
                
                
                if searchText.isEmpty {
                    List(arrayd,id:\.self) {result in
                        Text(result)
                        
                        
                    }
                }else {
                    let listArray =  correctionEngine.findSimilar(word: searchText.lowercased())
                    if listArray.isEmpty {
                        HStack {
                            Text("No results")
                                .padding(.leading, 5.0)
                        }
                        .padding(.top)
                        Spacer()
                        
                    }else {
                        let corrected = listArray.first
                        Text("Is this what you meant?\n \(corrected!.word)")
                            .padding(.leading, 5.0)
                        Spacer()
                    }
                    
                    
                    
                    
//                    List(listArray) {result in
//                        if searchText.isEmpty {
//                            Text(result.word)
//                        }else {
//                            HStack{
//                                Text(result.word)
//                                Spacer()
//                                Text("Similarity \(result.similarity)")
//                                    .foregroundColor(Color.gray)
//                            }
//                        }
//                    }
                }
            }
            .navigationTitle("Correction")
        }
    }
}

struct CorrectionView_Previews: PreviewProvider {
    static var previews: some View {
        CorrectionView()
    }
}
