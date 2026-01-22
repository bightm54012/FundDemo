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
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    fundDropdownMenu
                    
                    if let fund = viewModel.selectedFund {
                        FundInfoCard(fund: fund)
                        NavChartView(data: viewModel.navHistory, selectedDate: $viewModel.selectedDate)
                        purchaseSection
                    }
                }
                .padding()
            }
            .navigationTitle("基金申購")
            .task { await viewModel.loadData() }
        }
    }
    
    private var fundDropdownMenu: some View {
        Menu {
            ForEach(viewModel.funds) { fund in
                Button(fund.name) { Task { await viewModel.updateSelection(to: fund) } }
            }
        } label: {
            HStack {
                Text(viewModel.selectedFund?.name ?? "請選擇基金")
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding().background(Color.white).cornerRadius(10).shadow(radius: 1)
        }
    }
    
    private var purchaseSection: some View {
        VStack(spacing: 16) {
            HStack {
                TextField("單位數", text: $viewModel.unitsText).keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                Spacer()
                Text("NT$ \(viewModel.totalAmount, specifier: "%.2f")")
                    .font(.title2).bold().foregroundColor(.green)
            }
            Button("立即申購") { /* Action */ }
                .buttonStyle(.borderedProminent).tint(.green)
        }
        .padding().background(Color.green.opacity(0.05)).cornerRadius(12)
    }
}


