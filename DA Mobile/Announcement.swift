//
//  Announcement.swift
//  DA Mobile
//
//  Created by Yongyang Nie on 9/13/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

import UIKit

public class Announcement: NSObject {

    var title: String
    var postLink: String
    var announcementDescription: String
    
    public init (title: String, description: String, postLink: String){
        self.title = title
        self.postLink = postLink
        self.announcementDescription = description
    }
}
