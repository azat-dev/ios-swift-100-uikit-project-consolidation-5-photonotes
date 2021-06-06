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
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        imageView.image = 
        textField.text = note.name
    }
}
