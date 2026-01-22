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
        let dtos = try JSONDecoder().decode([FundDTO].self, from: data)
        return dtos.map { $0.toDomain() }
    }
    
    func fetchNavData(for fundId: String) async throws -> [NavPoint] {
        let url = URL(string: "https://f66d0ed1-fcb0-4c05-b5d2-e5b0a8159477.mock.pstmn.io/api/fund/nav")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let allDtos = try decoder.decode([NavDTO].self, from: data)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        
        let filteredPoints = allDtos.filter { $0.fundID == fundId }.compactMap { dto -> NavPoint? in
            guard let date = formatter.date(from: dto.navDate) else { return nil }
            return NavPoint(date: date, value: dto.nav)
        }
        
        return filteredPoints.sorted(by: { $0.date < $1.date })
    }
}
