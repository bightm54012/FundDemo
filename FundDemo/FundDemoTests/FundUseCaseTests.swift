//
//  FundUseCaseTests.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import XCTest
@testable import FundDemo

final class FundUseCaseTests: XCTestCase {
    var mockRepo: MockFundRepository!
    
    override func setUp() {
        mockRepo = MockFundRepository()
    }

    func testGetFundInfoUseCase_Success() async throws {
        // Arrange
        let expectedFunds = [Fund(id: "1", name: "Test Fund", category: "A", company: "C", latestNav: 10.0, inceptionDate: "2023/01/01")]
        mockRepo.mockFunds = expectedFunds
        let useCase = GetFundInfoUseCase(repository: mockRepo)
        
        // Act
        let result = try await useCase.execute()
        
        // Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
    }
}
