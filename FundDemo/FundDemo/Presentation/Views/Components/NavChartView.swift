//
//  NavChartView.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import SwiftUI
import Charts

struct NavChartView: View {
    let data: [NavPoint]
    
    // 修正點 3: 綁定類型改為 Date?
    @Binding var selectedDate: Date?
    
    // 內部計算：為了在 Overlay 顯示正確的淨值
    private var currentSelection: NavPoint? {
        guard let selectedDate = selectedDate else { return nil }
        return data.first { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("近三個月淨值走勢").font(.headline)
            
            Chart {
                ForEach(data) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("NAV", point.value)
                    )
                    .interpolationMethod(.catmullRom)
                }
                
                // 顯示選取線與點
                if let sel = currentSelection {
                    RuleMark(x: .value("Date", sel.date))
                        .foregroundStyle(.gray.opacity(0.2))
                    
                    PointMark(x: .value("Date", sel.date), y: .value("NAV", sel.value))
                        .foregroundStyle(.blue)
                        .symbolSize(100)
                }
            }
            .frame(height: 200)
            // 修正點 4: 這裡綁定的必須是 Date
            .chartXSelection(value: $selectedDate)
            .overlay {
                if let sel = currentSelection {
                    tooltipView(for: sel)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private func tooltipView(for point: NavPoint) -> some View {
        VStack {
            Text(point.date, format: .dateTime.month().day())
            Text("淨值：NT$ \(point.value, specifier: "%.2f")")
                .bold()
                .foregroundColor(.blue)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 3)
        .offset(y: -70)
    }
}
