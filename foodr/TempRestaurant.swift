//
//  TempRestaurant.swift
//  foodr
//
//  Created by Phong Bach on 4/19/21.
//

import UIKit

class TempRestaurant {
    var name: String
    var address: String
    var city: String
    var state: String
    var rating: Float
    var id: String
    var image: Data?
    var note: String?
    
    init(name: String,
         id: String,
         address: String,
         city: String,
         state: String,
         rating: Float,
         image: Data? = nil,
         note: String = "") {
        self.name = name
        self.id = id
        self.address = address
        self.city = city
        self.state = state
        self.rating = rating
        if let imageData = image {
            self.image = imageData
        }
        self.note = note
    }
}
