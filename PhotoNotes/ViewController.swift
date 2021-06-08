//
//  ViewController.swift
//  PhotoNotes
//
//  Created by Azat Kaiumov on 03.06.2021.
//

import UIKit
import AVFoundation

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DetailViewControllerDelegate {
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func imageSelected(image: UIImage) {
        openNewNoteViewController(image: image)
    }
    
    private func submitNote(title: String, image: UIImage) {
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
        
        notes.append(.init(name: title, image: fileName))
        
        let indexPath = IndexPath(row: notes.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        saveData()
    }
    
    private func openNewNoteViewController(image: UIImage) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "NewNoteViewController") as? NewNoteViewController else {
            fatalError("Can't instantiate NewNoteController")
        }
        
        viewController.didSubmit = {
            [weak self] title, image in self?.submitNote(title: title, image: image)
        }
        
        viewController.image = image
        present(viewController, animated: true)
    }
    
    func didChangeTitle(noteId: String, newTitle: String) {
        guard let noteIndex = notes.firstIndex(where: { $0.id == noteId}) else {
            return
        }
        
        notes[noteIndex].name = newTitle
        let indexPath = IndexPath(row: noteIndex, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func didRemove(noteId: String) {
        guard let noteIndex = notes.firstIndex(where: { $0.id == noteId}) else {
            return
        }
        
        
        let indexPath = IndexPath(row: noteIndex, section: 0)
        notes.remove(at: noteIndex)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell else {
            return
        }
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        guard let detailViewController = segue.destination as? DetailViewController else {
            return
        }
        
        let note = notes[indexPath.row]
        detailViewController.note = note
        detailViewController.delegate = self
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        takePictureByCamera()
    }
    
    @IBAction func unwindToViewController(_ unwindSegue: UIStoryboardSegue) {
        guard let segue = unwindSegue as? DetailViewControllerUnwindSegue else {
            return
        }
        
        segue.didComplete = {
            [weak self, weak segue] in
            guard let self = self else {
                return
            }
            
            guard let sourceController = segue?.source as? DetailViewController else {
                return
            }
            
            self.didRemove(noteId: sourceController.note.id)
        }
    }
}

// MARK: - Camera Methods
extension ViewController {
    func takePictureByCamera() {
        checkCameraAuthStatus()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        
        picker.dismiss(animated: true, completion: {
            self.imageSelected(image: image)
        })
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
        picker.sourceType = .photoLibrary
        
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
