//
//  NewMovieViewController.swift
//  Movies
//
//  Created by Brian Hu on 7/14/16.
//  Copyright © 2016 AlphaCamp. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewMovieViewController: UIViewController {
    
    @IBOutlet weak var imageNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var newMovieButton: UIButton!
    
    var ref: FIRDatabaseReference!
    
    @IBAction func createNewMovie(sender: AnyObject) {
        let imageName = imageNameTextField.text
        let name = nameTextField.text
        let description = descriptionTextView.text

        var movieInfo = ["name": name, "imageName": imageName, "description": description]
        if let user = FIRAuth.auth()?.currentUser {
            movieInfo["createdBy"] = user.uid
        }
        self.ref.child("movies").childByAutoId().setValue(movieInfo)
        newMovieButton.enabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signOut(sender: AnyObject) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }
}
