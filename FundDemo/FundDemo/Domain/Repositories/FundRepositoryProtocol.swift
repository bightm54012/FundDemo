//
//  FundRepositoryProtocol.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import Foundation

protocol FundRepositoryProtocol {
    func fetchFundInfo() async throws -> [Fund]
    func fetchNavData(for fundId: String) async throws -> [NavPoint]
}
