//
//  FundDemoApp.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import SwiftUI

@main
struct FundDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            FundPurchaseView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
