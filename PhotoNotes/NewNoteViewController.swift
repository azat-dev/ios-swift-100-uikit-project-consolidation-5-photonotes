//
//  NewNoteViewController.swift
//  PhotoNotes
//
//  Created by Azat Kaiumov on 06.06.2021.
//

import UIKit

class NewNoteViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textField: UITextField!
    
    var image: UIImage!
    var didSubmit: ((String, UIImage) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        initKeyboardEventsObserver()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let title = textField.text else {
            textField.shake()
            return
        }
        
        if title.isEmpty {
            textField.shake()
            return
        }
        
        dismiss(animated: true) {
            self.didSubmit(title, self.image)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - Keyboard Management
extension NewNoteViewController {
    private func initKeyboardEventsObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardSize.cgRectValue.height
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}