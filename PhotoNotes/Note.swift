//
//  Note.swift
//  PhotoNotes
//
//  Created by Azat Kaiumov on 03.06.2021.
//

import Foundation

struct Note: Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
