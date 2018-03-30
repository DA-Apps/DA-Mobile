//
//  Post.swift
//  DA Mobile
//
//  Created by Yongyang Nie on 9/13/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

import UIKit

public class Post: NSObject {
    
    var imageLink : String
    var title: String
    var postDescription: String
    var postLink: String
    var postType: String
    
    public init(image: String, title: String, postDescription: String, postLink: String, postType: String) {
        self.imageLink = image
        self.postLink = postLink
        self.title = title
        self.postDescription = postDescription
        self.postType = postType
    }

}
