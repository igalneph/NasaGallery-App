//
//  SavedDayImage.swift
//  NasaGallery
//
//  Created by Igal on 07/11/2021.
//

import SwiftUI

struct SavedDayImage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var dayImageModel: DayImageModel
    
    let photo: Photo
    
    @Namespace private var namespace
    @State private var isImageShown = false
    
    var body: some View {
        ZStack {
            if !isImageShown {
                VStack(alignment: .leading) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(photo.date.convertToString(inFormat: "dd.MM.yyyy"))
                                .font(.system(size: 14))
                            
                            if photo.image != nil {
                                Image(uiImage: photo.image!)
                                    .resizable()
                                    .scaledToFit()
                                    .matchedGeometryEffect(id: "image", in: namespace)
                                    .onTapGesture(count: 2) {
                                        withAnimation {
                                            self.isImageShown = true
                                        }
                                    }
                            }
                            
                            Text(photo.descript)
                                .font(.system(size: 19, weight: .regular, design: .rounded))
                                .lineSpacing(3)
                                .padding(.bottom, photo.copyright_ == nil ? 16 : 0)
                            
                            if let copyright = photo.copyright_ {
                                Divider()
                                
                                Text(copyright)
                                    .font(.callout)
                                    .foregroundColor(.black.opacity(0.8))
                                    .padding(.bottom)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            } else {
                Image(uiImage: photo.image!)
                    .resizable()
                    .scaledToFit()
                    .matchedGeometryEffect(id: "image", in: namespace)
                    .onTapGesture(count: 2) {
                        withAnimation {
                            self.isImageShown = false
                        }
                    }
            }
        }
        .navigationTitle(photo.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewContext.delete(photo)
                    try? viewContext.save()
                    print("Seriously??")
                    
                    guard let passedDate = dayImageModel.photo?.date_ else {
                        print("No")
                        return }
                    
                    if passedDate.isEqual(to: photo.date) {
                        dayImageModel.photo?.isFavorite = false
                    }
                }) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 18))
                }
            }
        }
        .navigationBarHidden(isImageShown)
    }
}

//struct SavedDaiImage_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedDayImage()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
