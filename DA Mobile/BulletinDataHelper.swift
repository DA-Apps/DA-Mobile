//
//  BulletinDataHelper.swift
//  DA-Mobile
//
//  Created by Yongyang Nie on 3/8/18.
//  Copyright © 2018 Yongyang Nie. All rights reserved.
//

import UIKit

class BulletinDataHelper: NSObject {
    
    public class func getDataType(input: String){
        
    }
    
    public class func cleanString(string: String) -> String {
        var str = string
        str = (str as NSString).replacingOccurrences(of: "\n", with: "")
        str = (str as NSString).replacingOccurrences(of: "\t", with: "")
        return str as String
    }

}
