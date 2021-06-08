//
//  DetailViewController.swift
//  PhotoNotes
//
//  Created by Azat Kaiumov on 06.06.2021.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func didChangeTitle(noteId: String, newTitle: String)
    func didRemove(noteId: String)
}

class DetailViewControllerUnwindSegue: UIStoryboardSegue {
    var didComplete: (() -> Void)?
    
    override func perform() {
        super.perform()
        didComplete?();
    }
}

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textField: TextFieldWithPadding!
    
    var note: Note!
    
    weak var delegate: DetailViewControllerDelegate?
    
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
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 15
        textField.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        textField.textPadding = .init(top: 5, left: 15, bottom: 5, right: 15)
        loadImage()
    }
    
    @IBAction func textFieldDone(_ sender: TextFieldWithPadding) {
        guard let title = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        if title.isEmpty {
            textField.shake(maxAmplitude: 15)
            return
        }
        
        delegate?.didChangeTitle(noteId: note.id, newTitle: title)
    }
}
