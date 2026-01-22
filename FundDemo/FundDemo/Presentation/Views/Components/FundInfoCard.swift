//
//  FundInfoCard.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import SwiftUI

struct FundInfoCard: View {
    let fund: Fund
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 0) {
                infoTile(icon: "doc.text", title: "基金代碼", value: fund.id)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                infoTile(icon: "chart.line.uptrend.xyaxis", title: "最新淨值", value: "NT$ \(fund.latestNav)", color: .green)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(alignment: .top, spacing: 0) {
                infoTile(icon: "tag", title: "基金類型", value: fund.category)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                infoTile(icon: "calendar", title: "成立日期", value: fund.inceptionDate)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            infoTile(icon: "building.2", title: "管理公司", value: fund.company)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func infoTile(icon: String, title: String, value: String, color: Color = .primary) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
                    .lineLimit(1)
            }
        }
    }
}
