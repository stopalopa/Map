//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Natasha Stopa on 4/26/20.
//  Copyright © 2020 Stopa Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        OnMapClient.createSessionId(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleSessionResponse(success:error:))
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
       if success {
               performSegue(withIdentifier: "completeLogin", sender: nil)
           } else {
               print("login Failed")
        }
    }

}
