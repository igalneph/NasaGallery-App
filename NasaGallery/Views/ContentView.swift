//
//  ContentView.swift
//  NasaGallery
//
//  Created by Igal on 06/11/2021.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Photo.date_, ascending: false)],
        animation: .default) private var photos: FetchedResults<Photo>
    
    @EnvironmentObject private var dayImageModel: DayImageModel
    
    var body: some View {
        TabView() {
            DayImage().tabItem {
                Image(systemName: "photo.on.rectangle")
                Text("Photo")
            }.tag(1)
            
            Favorites().tabItem {
                Image(systemName: "star")
                Text("Favourite")
            }.tag(2)
        }
        .onAppear {
            dayImageModel.setImage(for: Date() - 7200, savedPhotos: photos)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
