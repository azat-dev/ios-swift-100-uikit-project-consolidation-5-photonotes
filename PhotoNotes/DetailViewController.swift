//
//  DetailViewController.swift
//  PhotoNotes
//
//  Created by Azat Kaiumov on 06.06.2021.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textField: TextFieldWithPadding!
    
    var note: Note!
    var didRemoved: ((Int, Note) -> Void)!
    var didEdited: ((Int, Note) -> Void)!
    
    private func loadImage() {
        guard let documentsPath = FileManager.getDocumentsDirectory() else {
            return
        }
        
        let imagePath = documentsPath.appendingPathComponent(note.image)
        
        guard let image = UIImage(contentsOfFile: imagePath.path) else {
            return
        }
        
        imageView.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.text = note.name
        loadImage()
    }
}
