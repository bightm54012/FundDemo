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
                .background(Color.titleBlueBG)
                .foregroundColor(.white)
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("選擇基金")
                            .font(.caption)
                        fundDropdownMenu
                    }
                    .padding(.top)
                    
                    if let fund = viewModel.selectedFund {
                        // 2. 基金資訊卡片 (包含管理公司)
                        FundInfoCard(fund: fund)
                        
                        // 3. 圖表 (確保數據傳入)
                        NavChartView(data: viewModel.navHistory, selectedDate: $viewModel.selectedDate)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 0.5))
                        
                        // 4. & 5. 申購計算區塊
                        purchaseCalculationSection(fund: fund)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green, lineWidth: 0.5))
                    }
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(.white)
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
            HStack {
                Image(systemName: "dollarsign")
                    .foregroundColor(.darkGreen)
                Text("申購計算").font(.headline)
                Spacer()
            }
            
            HStack(alignment: .top, spacing: 15) {
                // 申購單位數
                VStack(alignment: .leading, spacing: 8) {
                    Text("申購單位數")
                        .font(.caption)
                    TextField("請輸入單位數", text: $viewModel.unitsText)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 0.5))
                    Text("每單位淨值: NT$ \(fund.latestNav, specifier: "%.2f")")
                        .font(.caption2).foregroundColor(.gray)
                }
                
                // 申購金額顯示
                VStack(alignment: .leading, spacing: 8) {
                    Text("申購金額")
                        .font(.caption)
                    Text("NT$ \(viewModel.totalAmount, specifier: "%.2f")")
                        .font(.title3).bold()
                        .foregroundColor(.darkGreen)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green, lineWidth: 0.5))
                    
                    // 顯示計算式
                    Text("\(viewModel.unitsText) 單位 × NT$ \(fund.latestNav, specifier: "%.2f")")
                        .font(.caption2).foregroundColor(.gray)
                }
            }
            
            // 確認申購按鈕
            Button(action: {
                // action
            }) {
                Text(viewModel.totalAmount > 0
                     ? "確認申購 NT$ \(viewModel.totalAmount, specifier: "%.2f")"
                     : "確認申購")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.totalAmount > 0 ? Color.darkGreen : Color.darkGreen.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.totalAmount <= 0)
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
}
