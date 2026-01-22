//
//  FundRepository.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import Foundation

class FundRepository: FundRepositoryProtocol {
    func fetchFundInfo() async throws -> [Fund] {
        let url = URL(string: "https://f66d0ed1-fcb0-4c05-b5d2-e5b0a8159477.mock.pstmn.io/api/fund/info")!
        let (data, _) = try await URLSession.shared.data(from: url)
        if let jsonString = String(data: data, encoding: .utf8) {
            print("API Response JSON: \(jsonString)")
        }
        let dtos = try JSONDecoder().decode([FundDTO].self, from: data)
        return dtos.map { $0.toDomain() }
    }
    
    func fetchNavData(for fundId: String) async throws -> [NavPoint] {
        let url = URL(string: "https://f66d0ed1-fcb0-4c05-b5d2-e5b0a8159477.mock.pstmn.io/api/fund/nav")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        
        let dtos = try decoder.decode([NavDTO].self, from: data)
        return dtos.compactMap { dto in
            guard let date = formatter.date(from: dto.navDate) else { return nil }
            return NavPoint(date: date, value: dto.nav)
        }
    }
}
