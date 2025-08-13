//
//  DayImageModel.swift
//  NasaGallery
//
//  Created by Igal on 06/11/2021.
//

import SwiftUI
import CoreData

struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    var date: String
    var isFavorite = false
    var date_: Date?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
        case date
    }
}

class DayImageModel: ObservableObject {
    
    @Published var photo: PhotoInfo?
    @Published var image: UIImage?
    @Published var imageStatus = ImageStatus.idle
    
    enum ImageStatus {
        case idle
        case fetching
        case failed
    }
    
    func setImage(for date: Date, savedPhotos: FetchedResults<Photo>) {
        
        image = nil
        photo = nil
        imageStatus = .fetching
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=pviQP59rYphmhg8EpCfgwag2coDzfcIXWhxS2ClU&date=\(date.convertToString())") else {
                DispatchQueue.main.async { [weak self] in
                    self?.imageStatus = .failed
                }
                return
            }
            guard let data = try? Data(contentsOf: url) else {
                DispatchQueue.main.async { [weak self] in
                    self?.imageStatus = .failed
                }
                return
            }
            guard let localInfo = try? JSONDecoder().decode(PhotoInfo.self, from: data) else { return }
            let imageURL = localInfo.url
            
            guard let imageData = try? Data(contentsOf: imageURL) else {
                DispatchQueue.main.async { [weak self] in
                    self?.setPhoto(date: date, receivedPhoto: localInfo, savedPhotos: savedPhotos)
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                if let image = UIImage(data: imageData) {
                    self?.image = image
                }
                self?.setPhoto(date: date, receivedPhoto: localInfo, savedPhotos: savedPhotos)
            }
        }
    }
    func savePhoto(viewContext: NSManagedObjectContext, date: Date) {

        let newPhoto = Photo(context: viewContext)
        newPhoto.title_ = photo?.title
        newPhoto.description_ = photo?.description
        newPhoto.date_ = photo?.date_
        newPhoto.copyright_ = photo?.copyright
        newPhoto.imageData_ = image?.jpegData(compressionQuality: 1.0)

        try? viewContext.save()
    }
    func compare(date: Date, inSavedPhotos photos: FetchedResults<Photo>) {
        for p in photos {
            if date.isEqual(to: p.date) {
                photo?.isFavorite = true
            }
        }
    }
    func setPhoto(date: Date, receivedPhoto: PhotoInfo, savedPhotos: FetchedResults<Photo>) {
        photo = receivedPhoto
        photo?.date_ = date
        imageStatus = .idle
        compare(date: date, inSavedPhotos: savedPhotos)
    }
}
