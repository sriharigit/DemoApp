//
//  LoginVC.swift
//  DemoApp
//
//  Created by Firoz on 14/07/19.
//  Copyright © 2019 Firoz. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    struct keys {
        
        static let login = "login"
        static let listVC = "ListVC"
        static let post = "POST"
        static let password_message = "please enter password"
        static let email_message = "please enter email"
        static let email = "email"
        static let password = "password"
        static let token = "token"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.clear.cgColor
        
        if UserDefaults.standard.bool(forKey: keys.login) == true
        {
            DispatchQueue.main.async {
                let listVC = self.storyboard!.instantiateViewController(withIdentifier: keys.listVC) as! ListVC
                self.navigationController!.pushViewController(listVC, animated: true)
            }
        }else {
            
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    @IBAction func loginBtnClicked(_ sender: UIButton){
        
        if emailTextField.text == ""{
            
            self.showAlert(title: "Alert", withMessage: keys.email_message)
            
        }else if passwordTextField.text == ""
        {
            self.showAlert(title: "Alert", withMessage: keys.password_message)
            
        }else
        {
            let postDict = NSMutableDictionary()
            postDict.setObject(self.emailTextField.text!, forKey : keys.email as NSCopying)
            postDict.setObject(self.passwordTextField.text!, forKey: keys.password as NSCopying)
            
            loginMethod(dictionary: postDict)
            
        }
    }
  

}
extension LoginVC {
    
     func loginMethod(dictionary:NSDictionary){
     
     let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
     let decoded = String(data: jsonData, encoding: .utf8)!
     
        WebserviceHelper.sharedInstance.executePOSTRequestWithUserInfo(userInfo: decoded, requestURL: URLConstant.login_Url, httpMethod: keys.post, isHud: true, hudView: self.view, successBlock:{ (response,success) in
           print("Login Status::\(response)")
     
     if success == true{
     
          UserDefaults.standard.set((response as! NSDictionary).value(forKey: keys.token), forKey: keys.token)
         UserDefaults.standard.set(true, forKey: keys.login)
    
        DispatchQueue.main.async {
            let listVC = self.storyboard!.instantiateViewController(withIdentifier: keys.listVC) as! ListVC
            self.navigationController!.pushViewController(listVC, animated: true)
        }
     
     } else
     {
     }
     })  { (error) in
     
     DispatchQueue.main.async {
        self.showAlert(title: "Alert", withMessage: "invalid credentials,please try again")
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
