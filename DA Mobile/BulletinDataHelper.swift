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

public extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}
