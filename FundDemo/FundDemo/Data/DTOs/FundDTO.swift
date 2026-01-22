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
            inceptionDate: setupDate
        )
    }
}
