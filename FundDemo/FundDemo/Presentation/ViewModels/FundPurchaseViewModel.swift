//
//  FundPurchaseViewModel.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import SwiftUI

@MainActor
class FundPurchaseViewModel: ObservableObject {
    @Published var funds: [Fund] = []
    @Published var selectedFund: Fund?
    @Published var navHistory: [NavPoint] = []
    @Published var unitsText: String = "1"
    
    @Published var selectedDate: Date?
    var selectedNavPoint: NavPoint? {
        guard let selectedDate = selectedDate else { return nil }
        // 尋找日期最接近的資料點
        return navHistory.first { point in
            Calendar.current.isDate(point.date, inSameDayAs: selectedDate)
        }
    }
    
    private let getFundInfoUseCase: GetFundInfoUseCase
    private let getNavInfoUseCase: GetNavInfoUseCase
    
    init(getFundInfoUseCase: GetFundInfoUseCase, getNavInfoUseCase: GetNavInfoUseCase) {
        self.getFundInfoUseCase = getFundInfoUseCase
        self.getNavInfoUseCase = getNavInfoUseCase
    }
    
    // Formula: Nav * Units = Amount
    var totalAmount: Double {
        let units = Double(unitsText) ?? 0
        return (selectedFund?.latestNav ?? 0) * units
    }
    
    func loadData() async {
        do {
            self.funds = try await getFundInfoUseCase.execute()
            if let firstFund = funds.first {
                await updateSelection(to: firstFund)
            }
        } catch {
            print("Failed to load funds: \(error)")
        }
    }
    
    func updateSelection(to fund: Fund) async {
        self.selectedFund = fund
        do {
            self.navHistory = try await getNavInfoUseCase.execute(for: fund.id)
        } catch {
            print("Failed to load nav: \(error)")
        }
    }
}
