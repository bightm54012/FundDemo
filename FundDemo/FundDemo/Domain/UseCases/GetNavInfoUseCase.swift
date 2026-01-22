//
//  GetNavInfoUseCase.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import Foundation

struct GetNavInfoUseCase {
    private let repository: FundRepositoryProtocol
    
    init(repository: FundRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(for fundId: String) async throws -> [NavPoint] {
        return try await repository.fetchNavData(for: fundId)
    }
}
