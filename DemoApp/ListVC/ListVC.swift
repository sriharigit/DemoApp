//
//  ListVC.swift
//  DemoApp
//
//  Created by Firoz on 14/07/19.
//  Copyright © 2019 Firoz. All rights reserved.
//

import UIKit

class ListVC: UIViewController {

    var listArray = NSMutableArray()
    
    @IBOutlet weak var listTableView: UITableView!
    
    struct keys {
        
        static let listCell = "ListCell"
        static let data = "data"
        static let updateVC = "UpdateVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfUserDetailsMethod()

    }
    
}
extension ListVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = listTableView.dequeueReusableCell(withIdentifier:keys.listCell, for: indexPath) as! ListCell
        
        let listModel = self.listArray.object(at: indexPath.row) as! ListModelClass
        
        
        cell.nameLbl.text = listModel.first_name!.capitalized
        cell.emailLbl.text = listModel.email!
        
        let url = URL(string:listModel.avatar!)
        
        if url != nil
        {
            let task = URLSession.shared.dataTask(with: url!) { (responseData, responseUrl, error) -> Void in
                // if responseData is not null...
                if let data = responseData{
                    DispatchQueue.main.async {
                        cell.profileImg.image  = UIImage(data: data)
                    }
                }
            }
            
            task.resume()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at:indexPath, animated: true)
        let updateVc = self.storyboard!.instantiateViewController(withIdentifier: keys.updateVC) as! UpdateVC
        updateVc.userDetailsModel = listArray.object(at: indexPath.row) as! ListModelClass
        self.navigationController!.pushViewController(updateVc, animated: true)
        
    }
    
}

extension ListVC {
    
    func listOfUserDetailsMethod(){
        
        var keyString = "per_page=30"
        keyString = keyString.replacingOccurrences(of: " ", with: "%20")
        keyString = "\(URLConstant.list_Url)\(keyString)"
        WebserviceHelper.sharedInstance.callGetDataWithMethod(userInfo:keyString, requestURL:"", isHud: true, hudView: self.view, successBlock: { (response,success) in
            
            if success == true{
                
                if (response as! NSDictionary).value(forKey: keys.data) is NSArray {
                    
                    for data in (response as! NSDictionary).value(forKey: keys.data) as! NSArray {
                        
                        let listModel = ListModelClass.init(jsonDict:data as! NSDictionary)
                        self.listArray.add(listModel)
                    }
            
                    DispatchQueue.main.async {
                        self.listTableView.reloadData()
                    }
                }
            }
        }, errorBlock: { (error) in
            // print(error.l)
        })
    }
}
