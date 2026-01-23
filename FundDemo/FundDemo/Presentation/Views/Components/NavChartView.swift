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
    @Binding var selectedDate: Date?
    
    private var chartMax: Double {
        let vals = data.map { $0.value }
        return ceil(vals.max() ?? 100)
    }
    
    private var chartMin: Double {
        let vals = data.map { $0.value }
        return floor(vals.min() ?? 0)
    }

    private var selectedPoint: NavPoint? {
        guard let selectedDate = selectedDate else { return nil }
        return data.first { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(Color.titleBlueBG)
                Text("近三個月淨值走勢")
                    .font(.headline)
            }
            
            GeometryReader { geometry in
                Chart {
                    ForEach(data) { point in
                        LineMark(
                            x: .value("日期", point.date),
                            y: .value("淨值", point.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.blue)
                    }
                    
                    if let sel = selectedPoint {
                        RuleMark(x: .value("日期", sel.date))
                            .foregroundStyle(.gray.opacity(0.2))
                        
                        PointMark(x: .value("日期", sel.date), y: .value("淨值", sel.value))
                            .foregroundStyle(.blue)
                            .symbolSize(100)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                            .foregroundStyle(.gray.opacity(0.3))
                        AxisValueLabel()
                    }
                }
                .chartXAxis {
                    let xValues: [Date] = {
                        guard data.count >= 2 else { return [] }
                        var dates: [Date] = []
                        let step = Double(data.count - 1) / 6.0
                        for i in 0...6 {
                            let index = Int(round(Double(i) * step))
                            if index < data.count {
                                dates.append(data[index].date)
                            }
                        }
                        return dates
                    }()
                    
                    AxisMarks(values: xValues) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                            .foregroundStyle(.gray.opacity(0.3))
                        
                        AxisValueLabel(
                            anchor: .top,
                            collisionResolution: .disabled,
                            offsetsMarks: true,
                            content: {
                                if let date = value.as(Date.self) {
                                    Text(date.formatted(.dateTime.month(.twoDigits).day(.defaultDigits)))
                                }
                            }
                        )
                    }
                }
                .chartPlotStyle { plotContent in
                    plotContent
                        .border(width: 1, edges: [.leading, .bottom], color: .gray.opacity(0.8))
                }
                .overlay(alignment: .topLeading) {
                    if let sel = selectedPoint {
                        tooltipOverlay(for: sel, in: geometry.size)
                    }
                }
                .chartYScale(domain: chartMin...chartMax)
                .chartXSelection(value: $selectedDate)
            }
            .frame(height: 250)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    @ViewBuilder
    private func tooltipOverlay(for point: NavPoint, in size: CGSize) -> some View {
        if let firstDate = data.first?.date, let lastDate = data.last?.date {
            let totalTime = lastDate.timeIntervalSince(firstDate)
            let currentTime = point.date.timeIntervalSince(firstDate)
            let xRatio = CGFloat(currentTime / totalTime)
            
            let leftGap: CGFloat = 10
            let rightGap: CGFloat = 25
            let tooltipWidth: CGFloat = 110
            let isTooRight = xRatio > 0.6
            
            VStack(alignment: .leading, spacing: 4) {
                Text(point.date.formatted(.dateTime.month(.twoDigits).day(.twoDigits)))
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("淨值：")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("NT$ \(point.value, specifier: "%.2f")")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.blue)
                }
            }
            .padding(8)
            .frame(width: tooltipWidth, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 8).fill(.white).shadow(radius: 3))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue.opacity(0.1)))
            .fixedSize()
            .offset(
                x: isTooRight ? (size.width * xRatio - tooltipWidth - leftGap) : (size.width * xRatio + rightGap),
                y: 30
            )
        } else {
            EmptyView()
        }
    }
}
