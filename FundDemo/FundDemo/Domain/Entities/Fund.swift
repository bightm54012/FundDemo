//
//  Fund.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import Foundation

struct Fund: Identifiable, Equatable {
    let id: String
    let name: String
    let category: String
    let company: String
    let latestNav: Double  // 最新淨值
    let inceptionDate: String // 成立日期
}
