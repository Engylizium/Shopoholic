//
//  ShopoholicApp.swift
//  Shopoholic
//
//  Created by Соболев Пересвет on 5/24/23.
//

import SwiftUI

@main
struct ShopoholicApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SignInView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
