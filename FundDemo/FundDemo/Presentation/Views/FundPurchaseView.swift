//
//  FundPurchaseView.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import SwiftUI

struct FundPurchaseView: View {
    @StateObject private var viewModel: FundPurchaseViewModel
    
    init() {
        let repo = FundRepository()
        _viewModel = StateObject(wrappedValue: FundPurchaseViewModel(
            getFundInfoUseCase: GetFundInfoUseCase(repository: repo),
            getNavInfoUseCase: GetNavInfoUseCase(repository: repo)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 1. 藍色背景 Header
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                        .frame(height: 35)
                    Text("台股基金申購平台")
                        .font(.title2)
                        .bold()
                    Text("選擇您的投資標的")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 30)
                .padding(.horizontal)
                .background(Color.blue)
                .foregroundColor(.white)
                
                VStack(spacing: 20) {
                    // 基金選擇選單
                    VStack(alignment: .leading, spacing: 8) {
                        Text("選擇基金").font(.caption).foregroundColor(.gray)
                        fundDropdownMenu
                    }
                    .padding(.top)
                    
                    if let fund = viewModel.selectedFund {
                        // 2. 基金資訊卡片 (包含管理公司)
                        FundInfoCard(fund: fund)
                        
                        // 3. 圖表 (確保數據傳入)
                        NavChartView(data: viewModel.navHistory, selectedDate: $viewModel.selectedDate)
                        
                        // 4. & 5. 申購計算區塊
                        purchaseCalculationSection(fund: fund)
                    }
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color(white: 0.98))
        .task { await viewModel.loadData() }
    }
    
    private var fundDropdownMenu: some View {
        Menu {
            ForEach(viewModel.funds) { fund in
                Button(fund.name) { Task { await viewModel.updateSelection(to: fund) } }
            }
        } label: {
            HStack {
                Text(viewModel.selectedFund?.name ?? "請選擇基金")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "chevron.down").foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 2)
        }
    }
    
    private func purchaseCalculationSection(fund: Fund) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("申購計算", systemImage: "dollarsign.circle")
                .font(.headline)
            
            HStack(alignment: .top, spacing: 15) {
                // 申購單位數
                VStack(alignment: .leading, spacing: 8) {
                    Text("申購單位數").font(.caption).foregroundColor(.gray)
                    TextField("輸入單位", text: $viewModel.unitsText)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(8)
                    Text("每單位淨值: NT$ \(fund.latestNav, specifier: "%.2f")")
                        .font(.caption2).foregroundColor(.gray)
                }
                
                // 申購金額顯示
                VStack(alignment: .trailing, spacing: 8) {
                    Text("申購金額").font(.caption).foregroundColor(.gray)
                    Text("NT$ \(viewModel.totalAmount, specifier: "%.2f")")
                        .font(.title3).bold()
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green.opacity(0.2)))
                    
                    // 顯示計算式
                    Text("\(viewModel.unitsText) 單位 × NT$ \(fund.latestNav, specifier: "%.2f")")
                        .font(.caption2).foregroundColor(.gray)
                }
            }
            
            // 確認申購按鈕
            Button(action: {}) {
                Text("確認申購 NT$ \(viewModel.totalAmount, specifier: "%.2f")")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
}
