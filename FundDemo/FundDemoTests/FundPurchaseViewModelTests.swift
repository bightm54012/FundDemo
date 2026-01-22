//
//  FundPurchaseViewModelTests.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import XCTest
@testable import FundDemo

@MainActor
final class FundPurchaseViewModelTests: XCTestCase {
    var viewModel: FundPurchaseViewModel!
    var mockRepo: MockFundRepository!
    
    override func setUp() {
        mockRepo = MockFundRepository()
        let getInfo = GetFundInfoUseCase(repository: mockRepo)
        let getNav = GetNavInfoUseCase(repository: mockRepo)
        viewModel = FundPurchaseViewModel(getFundInfoUseCase: getInfo, getNavInfoUseCase: getNav)
    }
    
    // 測試：申購金額計算邏輯 (Nav * Units)
    func testTotalAmountCalculation() {
        // Arrange
        let mockFund = Fund(id: "1", name: "Fund", category: "X", company: "Y", latestNav: 15.5, inceptionDate: "2022/01/01")
        viewModel.selectedFund = mockFund
        
        // Act
        viewModel.unitsText = "10"
        
        // Assert
        // 15.5 * 10 = 155.0
        XCTAssertEqual(viewModel.totalAmount, 155.0, "Total amount should be nav * units")
    }
    
    // 測試：當單位數輸入非法字串時，金額應為 0
    func testTotalAmountWithInvalidInput() {
        viewModel.selectedFund = Fund(id: "1", name: "Fund", category: "X", company: "Y", latestNav: 15.5, inceptionDate: "")
        
        viewModel.unitsText = "abc" // 非法輸入
        
        XCTAssertEqual(viewModel.totalAmount, 0, "Amount should be 0 for invalid unit text")
    }
    
    // 測試：載入資料並自動選取第一筆
    func testLoadDataAndAutoSelectFirstFund() async {
        // Arrange
        let mockFunds = [
            Fund(id: "F1", name: "First", category: "A", company: "C", latestNav: 10.0, inceptionDate: ""),
            Fund(id: "F2", name: "Second", category: "B", company: "C", latestNav: 20.0, inceptionDate: "")
        ]
        mockRepo.mockFunds = mockFunds
        
        // Act
        await viewModel.loadData()
        
        // Assert
        XCTAssertEqual(viewModel.funds.count, 2)
        XCTAssertEqual(viewModel.selectedFund?.id, "F1", "Should auto-select the first fund")
    }

    // 測試：圖表選取日期時，正確找回對應的 NavPoint
    func testSelectedNavPoint_MatchingDate() {
        // Arrange
        let targetDate = Date()
        let p1 = NavPoint(date: targetDate, value: 10.0)
        let p2 = NavPoint(date: targetDate.addingTimeInterval(86400), value: 11.0)
        viewModel.navHistory = [p1, p2]
        
        // Act
        viewModel.selectedDate = targetDate
        
        // Assert
        XCTAssertNotNil(viewModel.selectedNavPoint)
        XCTAssertEqual(viewModel.selectedNavPoint?.value, 10.0)
    }
    
    func testConfirmButtonEnableState() {
        // 1. 金額為 0 時
        viewModel.unitsText = "0"
        XCTAssertFalse(viewModel.totalAmount > 0, "金額為 0，按鈕應該判定為無效")
        
        // 2. 輸入有效金額時
        viewModel.selectedFund = Fund(id: "1", name: "Fund", category: "X", company: "Y", latestNav: 15.5, inceptionDate: "")
        viewModel.unitsText = "5"
        XCTAssertTrue(viewModel.totalAmount > 0, "金額大於 0，按鈕應該判定為有效")
    }
}
