//
//  GetFundInfoUseCase.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import Foundation

struct GetFundInfoUseCase {
    private let repository: FundRepositoryProtocol
    
    init(repository: FundRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Fund] {
        return try await repository.fetchFundInfo()
    }
}
