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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                infoTile(title: "基金代碼", value: fund.id)
                Spacer()
                infoTile(title: "最新淨值", value: "\(fund.latestNav)", color: .green)
            }
            Divider()
            HStack {
                infoTile(title: "基金類型", value: fund.category)
                Spacer()
                infoTile(title: "成立日期", value: fund.inceptionDate)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func infoTile(title: String, value: String, color: Color = .primary) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundColor(.gray)
            Text(value).font(.body).bold().foregroundColor(color)
        }
    }
}
