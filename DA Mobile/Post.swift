//
//  Post.swift
//  DA Mobile
//
//  Created by Yongyang Nie on 9/13/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

import UIKit

@objc public enum PostType: Int {
    case Athletics
    case StudentNews
    case LostFound
    case None
}

public class Post: NSObject {
    
    @objc public var date : Date
    @objc public var imageLink : String
    @objc public var title: String
    @objc public var content: String
    @objc public var link: String
    @objc public var type: PostType
    
    public init(date: Date, image: String, title: String, postDescription: String, postLink: String, postType: PostType) {
        self.date = date
        self.imageLink = image
        self.link = postLink
        self.title = title
        self.content = postDescription
        self.type = postType
    }

}
