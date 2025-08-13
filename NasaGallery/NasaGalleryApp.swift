//
//  NasaGalleryApp.swift
//  NasaGallery
//
//  Created by Igal on 06/11/2021.
//

import SwiftUI

@main
struct NasaGalleryApp: App {
    @ObservedObject private var dayImageModel = DayImageModel()
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(dayImageModel)
        }
    }
}
