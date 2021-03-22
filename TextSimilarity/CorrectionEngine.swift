//
//  CorrectionEngine.swift
//  SearchPOC
//
//  Created by Suthar, Bhavin Udavji on 18/03/21.
//

import Foundation
struct SearchResult:Identifiable{
    let id = UUID()
    let word: String
    let similarity: Double
}

class CorrectionEngine {
    let tfidf = TFIDF()
    let cosinSimilarity = CosineSimilarity()
    var vectorsOfAllVocab = [[Double]]()
    var vocabulary =  [String]()
    
    func setup(vocabulary: [String]) {
        self.vocabulary = vocabulary
        vectorsOfAllVocab = tfidf.fit(data: vocabulary)
    }
    
    func findSimilar(word: String) -> [SearchResult] {
        var similarWords = [SearchResult]()
        let vector = tfidf.transform(data: word)
        if !vectorsOfAllVocab.isEmpty {
            for i  in 0..<vectorsOfAllVocab.count {
               let similarity =  cosinSimilarity.getSimilarity(vector1: vectorsOfAllVocab[i], vector2: vector)
                if similarity > 0.0 {
                    similarWords.append(SearchResult(word: vocabulary[i], similarity: similarity))
                }
            }
        }
        return similarWords.sorted(by: {$0.similarity > $1.similarity})
    }
}
