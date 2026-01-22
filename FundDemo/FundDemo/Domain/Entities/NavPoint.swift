//
//  NavPoint.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import Foundation

struct NavPoint: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
    
    static func == (lhs: NavPoint, rhs: NavPoint) -> Bool {
        return lhs.date == rhs.date && lhs.value == rhs.value
    }
}
