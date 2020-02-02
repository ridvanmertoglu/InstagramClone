//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by RIDVAN on 28.01.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBOutlet weak var outletButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentField: UITextField!
    @IBAction func textField(_ sender: Any) {
    }
    
    func makeAlert(titleInput:String, otherInput:String){
        let alert = UIAlertController(title: titleInput, message: otherInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", otherInput: error?.localizedDescription ?? "Error!")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageURL = url?.absoluteString
                            
                            //database
                            let fireStoreDatabase = Firestore.firestore()
                            var fireStoreReference : DocumentReference? = nil
                            let fireStorePost = ["imageUrl" : imageURL!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentField.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            fireStoreReference = fireStoreDatabase.collection("Posts").addDocument(data: fireStorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error!", otherInput: error?.localizedDescription ?? "ERROR")
                                } else {
                                    self.imageView.image = UIImage(named: "selectImage.png")
                                    self.commentField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
