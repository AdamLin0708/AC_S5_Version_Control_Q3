//
//  SignInViewController.swift
//  Movies
//
//  Created by Brian Hu on 7/16/16.
//  Copyright © 2016 AlphaCamp. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var FBLoginButton: FBSDKLoginButton!
    @IBAction func signIn(sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordField.text
        
        FIRAuth.auth()?.signInWithEmail(email!, password: password!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                
                let alertController = UIAlertController(title: "There is something wrong.", message: "Maybe you put the wrong email/password, or you have not signed up yet", preferredStyle: .Alert)
                
                let fixAction = UIAlertAction(title: "Fix email/password", style: .Default, handler: nil)
                
                let signUpAction = UIAlertAction(title: "Sign Up", style: .Default, handler: { (action) in
                    self.signUp(self)
                })
                alertController.addAction(fixAction)
                alertController.addAction(signUpAction)
                self.showViewController(alertController, sender: self)
                
                return
            } else {
                self.performSegueWithIdentifier("SignIn To Main", sender: nil)
            }
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordField.text
        FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                self.performSegueWithIdentifier("SignIn To Main", sender: nil)
            }
        }
    }
    
    
    @IBAction func forgotPassword(sender: AnyObject) {
        let email = emailTextField.text

        FIRAuth.auth()?.sendPasswordResetWithEmail(email!) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // Password reset email sent.
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.FBLoginButton.delegate = self
        self.FBLoginButton.readPermissions = ["email"]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegueWithIdentifier("SignIn To Main", sender: nil)
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: result.token.tokenString, version: nil, HTTPMethod: "GET")
            req.startWithCompletionHandler({ (connection, graphResult, error : NSError!) -> Void in
                if(error == nil)
                {
                    print("result \(graphResult)")
                    user?.updateEmail(graphResult["email"] as! String, completion: nil)
                    if let user = user {
                        let reqeust = user.profileChangeRequest()
                        reqeust.displayName = graphResult["name"] as? String
                        reqeust.commitChangesWithCompletion(nil)
                    }
                }
                else {
                    print("error \(error)")
                }
            })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logged out!")
    }
}
