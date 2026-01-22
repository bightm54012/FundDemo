//
//  MockFundRepository.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import XCTest
@testable import FundDemo

class MockFundRepository: FundRepositoryProtocol {
    var mockFunds: [Fund] = []
    var mockNavData: [NavPoint] = []
    var shouldThrowError = false

    func fetchFundInfo() async throws -> [Fund] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return mockFunds
    }

    func fetchNavData(for fundId: String) async throws -> [NavPoint] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return mockNavData
    }
}
