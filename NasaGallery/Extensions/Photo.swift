//
//  Extensions.swift
//  NasaGallery
//
//  Created by Igal on 07/11/2021.
//

import SwiftUI

extension Photo {
    var title: String {
        title_ ?? ""
    }
    var descript: String {
        description_ ?? ""
    }
    var date: Date {
        if let passedDate = date_ {
            return passedDate
        } else {
            return Date()
        }
    }
    var image: UIImage? {
        if let data = imageData_ {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
