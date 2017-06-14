//
//  SignInVC.swift
//  MySocial
//
//  Created by mahmoud gamal on 6/10/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   
    @IBAction func fbBtnTapped(_ sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("FFFF Unable to authenticate with facebook\(error)")
            } else if result?.isCancelled == true {
                print("FFFF User Cancelled FB authentication")
            } else {
                print("FFFF Successifully authenticated")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential: credential)
            }
        }
    }
    
    func firebaseAuth(credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error == nil {
                print("FFFF Successifully authenticate with Firebase")
            } else {
                print("FFFF Unable to Authenticate with Firebase\(error)")
            }
        })
    }


}

