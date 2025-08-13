//
//  DayImage.swift
//  NasaGallery
//
//  Created by Igal on 07/11/2021.
//

import SwiftUI

struct DayImage: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Photo.date_, ascending: false)],
        animation: .default) private var photos: FetchedResults<Photo>
    
    @EnvironmentObject private var dayImageModel: DayImageModel
    
    @State private var date = Date()
    
    var body: some View {
        VStack {
            HStack {
                DatePicker("Day", selection: $date, in: ...(Date() - 7200), displayedComponents: .date)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onChange(of: date) { newValue in
                        dayImageModel.setImage(for: date, savedPhotos: photos)
                    }
                
                if let photo = dayImageModel.photo {
                    Button(action: {
                        if !photo.isFavorite {
                            dayImageModel.savePhoto(viewContext: viewContext, date: date)
                        } else {
                            for p in photos {
                                if date.isEqual(to: p.date) {
                                    viewContext.delete(p)
                                    
                                    try? viewContext.save()
                                }
                            }
                        }
                        
                        dayImageModel.photo!.isFavorite.toggle()
                    }) {
                        Image(systemName: photo.isFavorite ? "star.fill" : "star")
                            .font(.system(size: 25))
                    }
                }
            }
            
            if dayImageModel.imageStatus == .fetching {
                Spacer()
                
                CircleProgress()
            } else if dayImageModel.imageStatus == .failed {
                Spacer()
                
                Text("Ooops, something went wrong...")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
            }
            
            if let photo = dayImageModel.photo {
                Text(photo.title)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        if let image = dayImageModel.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        Text(photo.description)
                            .font(.system(size: 19, weight: .regular, design: .rounded))
                            .lineSpacing(3)
                            .padding(.bottom, photo.copyright == nil ? 16 : 0)
                        
                        if let copyright = photo.copyright {
                            Divider()
                            
                            Text(copyright)
                                .font(.callout)
                                .foregroundColor(.black.opacity(0.8))
                                .padding(.bottom, 16)
                        }
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding([.horizontal, .top])
    }
}

//struct DayImage_Previews: PreviewProvider {
//    static var previews: some View {
//        DayImage()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
