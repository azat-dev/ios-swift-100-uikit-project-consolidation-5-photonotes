//
//  Extensions.swift
//  PhotoNotes
//
//  Created by Azat Kaiumov on 05.06.2021.
//

import Foundation

extension FileManager {
    static func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.count > 0 ? paths[0] : nil
    }
}
