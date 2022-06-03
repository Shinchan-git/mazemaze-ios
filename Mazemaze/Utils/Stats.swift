//
//  Stats.swift
//  Mazemaze
//
//  Created by Owner on 2022/06/04.
//

import Foundation

class Stats {
    
    static func mode(ofString array:[String]) -> [String]? {
        var sameList: [String] = []
        var countList: [Int] = []
        for item in array{
            if let index = sameList.firstIndex(of: item){
                countList[index] += 1
            } else {
                sameList.append(item)
                countList.append(1)
            }
        }
        guard let maxCount = countList.max() else { return nil }
        var modeList: [String] = []
        for index in 0..<countList.count{
            if countList[index] == maxCount {
                modeList.append(sameList[index])
            }
        }
        return modeList
    }
    
}
