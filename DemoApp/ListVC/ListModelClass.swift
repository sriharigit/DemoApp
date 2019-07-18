//
//  ListModelClass.swift
//  DemoApp
//
//  Created by Firoz on 14/07/19.
//  Copyright © 2019 Firoz. All rights reserved.
//

import UIKit

class ListModelClass: NSObject {

    var id:Int?
    var email:String?
    var first_name:String?
    var last_name:String?
    var avatar:String?
    
    override init() {
        
         super.init()
    }
    
    convenience  init(jsonDict:NSDictionary) {
        
        self.init()
        
        self.id = jsonDict["id"] as? Int
        self.email = jsonDict["email"] as? String ?? ""
        self.first_name = jsonDict["first_name"] as? String ?? ""
        self.last_name = jsonDict["last_name"] as? String ?? ""
        self.avatar = jsonDict["avatar"] as? String ?? ""
        
    }
    
}
