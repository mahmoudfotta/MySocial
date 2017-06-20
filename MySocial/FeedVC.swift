//
//  FeedVC.swift
//  MySocial
//
//  Created by mahmoud gamal on 6/14/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var captionField: CustomTextField!
    @IBOutlet weak var imageAdd: CircleImageView!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var feedTable: UITableView!
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTable.delegate = self
        feedTable.dataSource = self
        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let id = snap.key
                        let post = Post(postId: id, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.feedTable.reloadData()
        })
        
        
    }
    
    @IBAction func signoutTapped(_ sender: AnyObject) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
    @IBAction func addImageTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: AnyObject) {
        guard let caption = captionField.text, caption != "" else {
            print("Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("Image must be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            let imageUid = UUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imageUid).put(imageData, metadata: metaData, completion: { (metaData, error) in
                if error == nil {
                    let dawnloadUrl = metaData?.downloadURL()?.absoluteString
                    print("SUCCESS \(dawnloadUrl)")
                } else {
                    print("ERROR \(error?.localizedDescription)")
                }
            })
        }
    }
    
    // MARK: tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = feedTable.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
            print(FeedVC.imageCache.countLimit)
            if let img = FeedVC.imageCache.object(forKey: posts[indexPath.row].imageUrl as NSString) {
                cell.configureCell(post: posts[indexPath.row], img: img)
                return cell
            } else {
                cell.configureCell(post: posts[indexPath.row])
                return cell
            }
        } else {
            return PostCell()
        }
    }
    
}
