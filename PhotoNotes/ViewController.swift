//
//  ViewController.swift
//  PhotoNotes
//
//  Created by Azat Kaiumov on 03.06.2021.
//

import UIKit
import AVFoundation

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var notes = [Note]()
    
    private func initNavBar() {
        title = "Photo Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        initNavBarAddButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
        loadData()
    }
    
    private func initNavBarAddButton() {
        navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }
    
    private func imageSelected(image: UIImage) {
        guard let jpegData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        guard let documentsPath = FileManager.getDocumentsDirectory() else {
            return
        }
        
        let fileName = UUID().uuidString
        let filePath = documentsPath.appendingPathComponent(fileName)
        
        do {
            try jpegData.write(to: filePath)
        } catch {
            return
        }
        
        notes.append(.init(name: "Unknown", image: fileName))
        
        let indexPath = IndexPath(row: notes.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        saveData()
    }
    
    @objc private func addButtonTapped() {
        takePictureByCamera()
    }
}

// MARK: - Camera Methods
extension ViewController {
    func takePictureByCamera() {
        checkCameraAuthStatus()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer { picker.dismiss(animated: true) }
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        imageSelected(image: image)
    }
    
    private func alertCameraAccessNeeded() {
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to make full use of this app",
            preferredStyle: .alert
        )
        
        
        let allowAction = UIAlertAction(title: "Allow Camera", style: .default) { _ in
            let settingsAppUrl = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(settingsAppUrl, options: [:])
        }
        
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(allowAction)
        
        present(alert, animated: true)
    }
    
    private func openCamera() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .camera
        
        present(picker, animated: true)
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) {
            [weak self] isAccessGranted in
            
            guard isAccessGranted else {
                return
            }
            
            self?.openCamera()
        }
    }
    
    private func checkCameraAuthStatus() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            requestCameraPermission()
        case .restricted, .denied:
            alertCameraAccessNeeded()
        case .authorized:
            openCamera()
        @unknown default:
            return
        }
    }
}

// MARK: - Saving Data Methods
extension ViewController {
    private func saveData() {
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(notes) else {
            return
        }
        
        UserDefaults.standard.setValue(data, forKey: "notes")
    }
    
    private func loadData() {
        guard let data = UserDefaults.standard.object(forKey: "notes") as? Data else {
            return
        }
        
        let decoder = JSONDecoder()
        
        guard let savedNotes = try? decoder.decode([Note].self, from: data) else {
            return
        }
        
        notes = savedNotes
    }
}

// MARK: - Table View Methods
extension ViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
}
