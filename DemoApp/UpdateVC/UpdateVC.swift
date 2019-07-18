//
//  UpdateVC.swift
//  DemoApp
//
//  Created by Firoz on 15/07/19.
//  Copyright © 2019 Firoz. All rights reserved.
//

import UIKit

class UpdateVC: UIViewController {

    var userDetailsModel = ListModelClass()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    
    struct keys {
        
        static let first_name = "first_name"
        static let email = "email"
        static let put = "PUT"
        static let name_message = "please enter name"
        static let email_message = "please enter email"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = userDetailsModel.first_name!
        emailTextField.text = userDetailsModel.email!
        
        updateBtn.layer.cornerRadius = 5
        updateBtn.layer.borderWidth = 1
        updateBtn.layer.borderColor = UIColor.clear.cgColor

    }

    @IBAction func updateBtnClicked(_ sender: Any) {
        
        if nameTextField.text == ""{
            
            self.showAlert(title: "Alert", withMessage:keys.name_message)
            
        }else if emailTextField.text == ""
        {
            self.showAlert(title: "Alert", withMessage: keys.email_message)
            
        }else
        {
            let postDict = NSMutableDictionary()
            postDict.setObject(self.nameTextField.text!, forKey : keys.first_name as NSCopying)
            postDict.setObject(self.emailTextField.text!, forKey: keys.email as NSCopying)
            updateUserDetails(dictionary: postDict)
    }
  }
        
    @IBAction func backBtnClicked(_ sender: Any) {
        
        self.navigationController!.popViewController(animated: true)
    }
}

extension UpdateVC {
    
    func updateUserDetails(dictionary:NSDictionary){
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        
        let update_Url = "\(URLConstant.update_Url)\(userDetailsModel.id!)"
        WebserviceHelper.sharedInstance.executePOSTRequestWithUserInfo(userInfo: decoded, requestURL:update_Url , httpMethod: keys.put, isHud: true, hudView: self.view, successBlock:{ (response,success) in
            print("Login Status::\(response)")
            
            if success == true{
                
                DispatchQueue.main.async {
                  
                    self.navigationController!.popViewController(animated: true)
                }
                
            } else
            {
            }
        })  { (error) in
            
            DispatchQueue.main.async {
                //self.showAlert(title: "Alert", withMessage: "invalid credentials,please try again")
            }
        }
    }
    
    func showAlert(title: String, withMessage  message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK" , style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
  }
}
