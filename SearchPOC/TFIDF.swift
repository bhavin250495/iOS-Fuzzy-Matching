//
//  TFIDF.swift
//  SearchPOC
//
//  Created by Suthar, Bhavin Udavji on 18/03/21.
//

import Foundation

class TFIDF{
    typealias dict = [String: Double]
    var wordCount = [[String:Int]]()
    var sortedUnique = [String]()
    var idfs = dict()
    
    func transform(data:String) -> [Double]{
        let preprocessedArray = preprocessText(text: data)
        var stringLists = [ngram(text: preprocessedArray, length: 2)]
        
        stringLists = [Array(Set(stringLists[0]).intersection(Set(sortedUnique)))]
        //Only get the count of n-gram present  while dping fit()
        wordCount = counter(stringLists: stringLists,wordSetArray: sortedUnique)

        let tfDict = computeTF(wordDict: wordCount[0], doc: stringLists[0])
      
        var arr: [Double] = Array.init(repeating: 0.0, count: sortedUnique.count)
        
            let tfidf = computeTFIDF(tbow: tfDict, idf: idfs)
            let keys = tfidf.keys.sorted()
            for j in 0..<arr.count{
                arr[j] = tfidf[keys[j]]!
            }
        
        let invalid = arr.map({$0.isNaN}).contains(true)
        if invalid {
            return Array.init(repeating: 0.0, count: sortedUnique.count)
        }
         
        let normaArr = normalize(idfDict: arr)
        return normaArr
    }
    
    func fit(data:[String]) -> [[Double]]{
        
        let preprocessedArray = data.map({ preprocessText(text: $0) })
        let stringLists = preprocessedArray.map({ ngram(text: $0, length: 2) })
        let wordSetArray = Set(stringLists.flatMap( {$0}))
        sortedUnique = wordSetArray.sorted()
        
        wordCount = counter(stringLists: stringLists,wordSetArray: sortedUnique)
        

        var tfDict = [dict]()
        for item in zip(wordCount,stringLists) {
            tfDict.append(computeTF(wordDict: item.0, doc: item.1))
        }
        idfs = computeIDF(wordSetArray: sortedUnique, docList: wordCount)
        var arr: [[Double]] = Array.init(repeating: Array.init(repeating: 0, count: sortedUnique.count), count: data.count)
        for i in 0..<tfDict.count {
            let tfidf = computeTFIDF(tbow: tfDict[i], idf: idfs)
            let keys = tfidf.keys.sorted()
            for j in 0..<arr[i].count{
                arr[i][j] = tfidf[keys[j]]!
            }
            
        }
        
        let normaArr = arr.map({ normalize(idfDict: $0)})
        return normaArr
        
    }
    func preprocessText(text: String) -> String {
        let ltext = text.lowercased()
        let regex = try! NSRegularExpression.init(pattern: "[,-./]\\s{1,}", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, ltext.count)
        let modString = regex.stringByReplacingMatches(in: ltext, options: [], range: range, withTemplate: "")
        return modString
    }
    func ngram(text: String, length: Int = 3) -> [String]{
        var ngrams:[String] = []
        for i in 0..<text.count-1 {
            let start = String.Index(utf16Offset: i, in: text)
            let end = String.Index(utf16Offset: i+length, in: text)
            let substring = String(text[start..<end])
            ngrams.append(substring)
        }
        return ngrams
    }
    
    func counter(stringLists: [[String]],wordSetArray:[String]) -> [[String:Int]] {
        var wordCount = [[String:Int]] ()
        
        
        for stringArray in stringLists {
            
            var dict = [String:Int]()
            for word in wordSetArray {
                dict[word] = 0
            }
            for string in stringArray {
                if let _ = dict[string] {
                    dict[string]! += 1
                } else {
                    dict[string] = 1
                }
            }
            wordCount.append(dict)
        }
        return wordCount
    }
    
    
    
    func computeTF(wordDict: [String:Int], doc: [String]) -> dict{
        var tfDict = dict()
        /// TF(t) = (Number of times term t appears in a document) / (Total number of terms in the document)
        for (word,count) in wordDict {
            tfDict[word] =  Double( Double(count) / Double(doc.count) )
        }
        return tfDict
    }
    
    func computeIDF(wordSetArray:[String], docList: [[String:Int]]) -> dict {
        let N = docList.count
        var idfDict = dict()
        for word in wordSetArray {
            idfDict[word] = 0
        }
        
        for doc in docList {
            for (word,val) in doc {
                if val > 0 {
                    idfDict[word]!+=1
                }
            }
        }
         var values = [Double]()
        
        ///IDF(t) = log_e(Total number of documents / Number of documents with term t in it)
        for (word,val) in idfDict {
            idfDict[word] = log(Double(N+1)/Double(val+1))+1
            values.append(idfDict[word]!)
        }

        return idfDict
    }
    
    func normalize( idfDict:  [Double]) -> [Double]{
        var arr = [Double]()
        let bc = idfDict.map({$0*$0})
        let sum = bc.reduce(0, +)
        let result = sqrt(sum)
        
        for i in 0..<idfDict.count {
             let normVal = idfDict[i]/result
            arr.append(normVal)
        }
        return arr
    }
    
    func computeTFIDF(tbow:dict, idf:dict) -> dict{
        var tfidf = dict()
        for (word,val) in tbow {
            tfidf[word] = val * (idf[word]  ?? 0)
        }
        return tfidf
    }
}
