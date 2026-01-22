//
//  FundDTO.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import Foundation

struct FundDTO: Codable {
    let fundID: String
    let fundName: String
    let nav: Double
    let setupDate: String
    let companyName: String
    let paramVal: String
    
    func toDomain() -> Fund {
        return Fund(
            id: fundID,
            name: fundName,
            category: paramVal,
            company: companyName,
            latestNav: nav,
            inceptionDate: DateParser.formatToYMD(setupDate)
        )
    }
}

struct DateParser {
    static func formatToYMD(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        // 這裡對應 API 的 "10/3/2025" 格式
        inputFormatter.dateFormat = "M/d/yyyy"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy/MM/dd"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString // 若解析失敗則回傳原字串
    }
}
