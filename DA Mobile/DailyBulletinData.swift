//
//  DailyBulletinData.swift
//  DA Mobile
//
//  Created by Yongyang Nie on 9/14/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

import UIKit

public class DailyBulletinData: NSObject {
    
    @objc public var menu: [String]?
    @objc public var posts : [Post]?
    @objc public var announcements : [Announcement]?
    @objc public var dateString : String
    
    public init(posts: [Post]?, announcements: [Announcement]?, menu: [String]?, date: String) {
        self.posts = posts
        self.announcements = announcements
        self.menu = menu
        self.dateString = date
    }

}
