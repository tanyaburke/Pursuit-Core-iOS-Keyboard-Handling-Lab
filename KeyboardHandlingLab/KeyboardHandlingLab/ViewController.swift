//
//  ViewController.swift
//  KeyboardHandlingLab
//
//  Created by Tanya Burke on 2/3/20.
//  Copyright © 2020 Tanya Burke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var logoTopYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackviewTopYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pursuitLogo: UIImageView!
    
    private var originalCenterY: NSLayoutConstraint!
       
       private var keyboardIsVisible = false
       
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerForKeyBoardNotification()
        userNameTextField.delegate = self
        passWordTextField.delegate = self
         pulsateLogo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterForKeyBoardNotification()
    }
    
    
    private func registerForKeyBoardNotification(){
       //create a singleton
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unregisterForKeyBoardNotification(){
      
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc
        private func keyboardWillShow(_ notification: NSNotification){
    //        print("keyboardWillShow")
    //        print(notification.userInfo) - test, to get the user info
            
            //now that we got the key that was printed out we use it
            guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else{
               return
        }
    //     print("keyboard frame is \(keyboardFrame)")
            
            moveKeyboardUP(keyboardFrame.size.height/2)
        }
      

        
        
        
        @objc
        private func keyboardWillHide(_ notification: NSNotification){
            print("keyboardWillHide")
                   print(notification.userInfo)
             resetUI()
        }
        
        private func moveKeyboardUP(_ height: CGFloat){
            if  keyboardIsVisible {return}
            originalCenterY = stackviewTopYConstraint //saves the original before it gets changed
    stackviewTopYConstraint.constant -= height
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5.0, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            keyboardIsVisible = true
        }
        
        private func resetUI(){
            keyboardIsVisible = false
            //if original is 0, you -314, you gave to +314 to get back
            //pursuitLogoCenterYConstraint.constant = 0
            stackviewTopYConstraint.constant += originalCenterY.constant * 0.80
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
        }
        private func pulsateLogo(){
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse, .repeat], animations: {
                self.pursuitLogo.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: nil)
        }
    }

    extension ViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            resetUI()
            return true
        }
        

}

