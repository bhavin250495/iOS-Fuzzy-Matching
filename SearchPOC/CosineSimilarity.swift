//
//  CosineSimilarity.swift
//  SearchPOC
//
//  Created by Suthar, Bhavin Udavji on 18/03/21.
//

import Foundation
import Accelerate
import simd

class CosineSimilarity {
    public func transpose<T>(input: [[T]]) -> [[T]] {
        if input.isEmpty { return [[T]]() }
        let count = input[0].count
        var out = [[T]](repeating: [T](),count: count)
        for outer in input {
            for (index, inner) in outer.enumerated() {
                out[index].append(inner)
            }
        }

        return out
    }
    
    func getSimilarity(vector1: [Double], vector2: [Double]) -> Double{
        var result: Double = .nan
        vDSP_dotprD(vector1, 1, vector2, 1, &result, vDSP_Length(vector1.count))
        return result
    }
}
