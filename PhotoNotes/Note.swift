//
//  Note.swift
//  PhotoNotes
//
//  Created by Azat Kaiumov on 03.06.2021.
//

import Foundation

class Note: Codable {
    var id: String
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.id = UUID().uuidString
        self.name = name
        self.image = image
    }
}
