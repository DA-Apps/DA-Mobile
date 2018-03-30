//
//  DailyBulletinData.swift
//  DA Mobile
//
//  Created by Yongyang Nie on 9/14/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

import UIKit

class DailyBulletinData: NSObject {
    
    var menu: [String]?
    var posts : [Post]?
    var announcements : [Announcement]?
    
    public init(posts: [Post]?, announcements: [Announcement]?, menu: [String]?) {
        self.posts = posts
        self.announcements = announcements
        self.menu = menu
    }

}
