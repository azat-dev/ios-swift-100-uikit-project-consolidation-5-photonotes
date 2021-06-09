//
//  NewNoteViewController.swift
//  PhotoNotes
//
//  Created by Azat Kaiumov on 06.06.2021.
//

import UIKit

class NewNoteViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textField: TextFieldWithPadding!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var innerView: UIView!
    @IBOutlet var innerViewBottomConstraint: NSLayoutConstraint!
    
    var image: UIImage!
    var didSubmit: ((String, UIImage) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        textField.textPadding = .init(top: 5, left: 15, bottom: 5, right: 15)
        closeButton.layer.zPosition = 10
        initKeyboardEventsObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func submit() {
        guard let title = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            textField.shake(maxAmplitude: 10.0)
            return
        }
        
        if title.isEmpty {
            textField.shake(maxAmplitude: 10.0)
            return
        }
        
        dismiss(animated: true) {
            self.didSubmit?(title, self.image)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        submit()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func textFieldDone(_ sender: Any) {
        submit()
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
        
        if innerViewBottomConstraint.constant == 0 {
            innerViewBottomConstraint.constant = keyboardSize.cgRectValue.height
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide() {
        if innerViewBottomConstraint.constant != 0 {
            innerViewBottomConstraint.constant = 0
            view.layoutIfNeeded()
        }
    }
}
