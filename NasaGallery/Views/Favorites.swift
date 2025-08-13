//
//  Favorites.swift
//  NasaGallery
//
//  Created by Igal on 07/11/2021.
//

import SwiftUI

struct Favorites: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Photo.date_, ascending: false)],
        animation: .default) private var photos: FetchedResults<Photo>
    
    var body: some View {
        if photos.isEmpty {
            Text("No Favorite Photos Added")
                .font(.title)
        } else {
            NavigationView {
                List {
                    ForEach(photos) { photo in
                        NavigationLink(destination: SavedDayImage(photo: photo)) {
                            HStack(spacing: 16) {
                                if let image = photo.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .stroke(lineWidth: 1)
                                        .frame(width: 50, height: 50)
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(photo.title)
                                        .font(.system(size: 19))
                                        .lineLimit(1)
                                    
                                    Text(photo.date_?.convertToString(inFormat: "dd.MM.yyyy") ?? "")
                                        .font(.system(size: 14))
                                }
                                
                            }
                            .padding(.vertical)
                        }
                    }
                }
                .navigationTitle(Text("Favourite"))
            }
        }
    }
}

//struct Favorites_Previews: PreviewProvider {
//    static var previews: some View {
//        Favorites()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
