//
//  Breed.swift
//  DogeFinder
//
//  Created by Cameron Pierce on 2/4/18.
//  Copyright © 2018 Cameron Pierce. All rights reserved.
//

import Foundation

class Breed: NSObject {

    var id: String?
    var name: String?
    var subname: String?
    var fullName: String?
    var imageUrls: [String]? = nil

    init(with breed: String, and subBreed: String) {
        self.id = breed + subBreed
        self.name = breed
        self.subname = subBreed

        var fullName = ""
        if !subBreed.isEmpty {
            fullName = "\(subBreed) \(breed)"
        } else {
            fullName = breed
        }
        self.fullName = fullName.capitalized
    }
}
