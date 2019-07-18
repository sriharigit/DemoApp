//
//  WebserviceHelper.swift
//  
//
//  Created by webwerks on 3/16/17.
//  Copyright © 2017 Webwerks. All rights reserved.
//

import UIKit
let baseUrl:String = "https://reqres.in"
class WebserviceHelper: NSObject {
    static let sharedInstance : WebserviceHelper = {
        let instance = WebserviceHelper()
        return instance
    }()
    
    
    func executePOSTRequestWithUserInfo(userInfo:String, requestURL:String ,httpMethod:String, isHud:Bool, hudView: UIView, successBlock:@escaping (_ response:Any,_ success:Bool )->Void, errorBlock:@escaping (_ error:Any)->Void)  -> Void
    {
        
        /*
        DispatchQueue.main.async {
            if isHud{
                let spinnerActivity = MBProgressHUD.showAdded(to: hudView, animated: true);
                spinnerActivity.label.text = "Loading";
                spinnerActivity.detailsLabel.text = "Please Wait";
                spinnerActivity.isUserInteractionEnabled = false;
            }
        }
        */
        let configuration = URLSessionConfiguration.default;
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        var urlString = String()
        urlString.append(baseUrl)
        urlString.append(requestURL)
        
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverUrl: URL = URL(string: (encodedUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!
        var request : URLRequest = URLRequest(url: serverUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        
        let postData:Data = userInfo.data(using: .utf8)!
        let reqJSONStr = String(data: postData, encoding: .utf8)
        
        request.httpMethod = httpMethod
        //request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if UserDefaults.standard.object(forKey: "token") !=  nil
        {
          request.addValue("\("Bearer ")\(UserDefaults.standard.object(forKey: "token")!)", forHTTPHeaderField:"Authorization")
        }else
        {
            
        }
        
        request.httpBody = reqJSONStr?.data(using: .utf8)
        
        let postDataTask : URLSessionDataTask = session.dataTask(with: request, completionHandler:
        {
            data, response, error in
            
            let httpResponse = response as? HTTPURLResponse
            let statusCode: Int? = httpResponse?.statusCode
            
            if statusCode == 200
            {
                if data != nil && error == nil {
                    do {
                        
                        let responseStr = try JSONSerialization.jsonObject(with: (data)!, options: .mutableContainers) as! NSDictionary
                        print("responseStr\(responseStr)")
                        DispatchQueue.main.async {
                            successBlock(responseStr, true)
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            errorBlock(error.localizedDescription)
                        }
                    }
                }
                else{
                    errorBlock((error?.localizedDescription)! as String)
                }
                DispatchQueue.main.async{
                   // MBProgressHUD.hide(for: hudView, animated: true)
                }
                
            }else
            {
                errorBlock((error?.localizedDescription))
                print(errorBlock((error?.localizedDescription) as? String))
            }
            
            DispatchQueue.main.async{
               // MBProgressHUD.hide(for: hudView, animated: true)
            }
        })
        postDataTask.resume()
        
    }

    func callGetDataWithMethod(userInfo:String,requestURL:String,isHud:Bool, hudView: UIView,successBlock:@escaping (_ response:Any,_ success:Bool)->Void, errorBlock:@escaping (_ error:Any)->Void)  {
    
//        DispatchQueue.main.async {
//           // let spinnerActivity = MBProgressHUD.showAdded(to: hudView, animated: true);
//               spinnerActivity.label.text = "Loading";
//               spinnerActivity.detailsLabel.text = "Please Wait";
//               spinnerActivity.isUserInteractionEnabled = false;
//        }
        var urlString = String()
        urlString.append(baseUrl)
        urlString.append(userInfo)
    
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        print(url!)
        let request = NSMutableURLRequest(url: url! as URL)
        
       // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\("Bearer ")\(UserDefaults.standard.object(forKey: "token")!)", forHTTPHeaderField:"Authorization")
        
            print("\("Bearer ")\(UserDefaults.standard.object(forKey: "token")!)")
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
            
            let httpResponse = response as? HTTPURLResponse
            let statusCode: Int? = httpResponse?.statusCode
            
            if statusCode == 200
            {
                if data != nil && error == nil{
                    do {
            //    let array = try JSONDecoder().decode([LoginData].self, from: data!, keyPath: "response.data")
            // array.forEach { print($0) } // decoded!!!!!
            let responseStr = try JSONSerialization.jsonObject(with: (data)!, options: .mutableContainers) as! NSDictionary
                        print("responseStr:\(responseStr)")
                        
                        DispatchQueue.main.async {
                            successBlock(responseStr,true)
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            errorBlock(error.localizedDescription)
                        }
                    }
                }else
                {
                    print("Failed to load: \(error?.localizedDescription)")
                    DispatchQueue.main.async {
                        errorBlock(error?.localizedDescription ?? "")
                    }
                }
            
            }
            DispatchQueue.main.async {
//                MBProgressHUD.hideAllHUDs(for: hudView, animated: true);
              //  MBProgressHUD.hide(for: hudView, animated: true)
            }
        })
        dataTask.resume()
    }
    
 
}



