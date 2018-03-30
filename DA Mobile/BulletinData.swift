//
//  BulletinData.swift
//  
//
//  Created by Yongyang Nie on 9/13/17.
//

import UIKit

protocol BulletinDataDelegate {
    func recievedNewData(posts: [Post]?, announcements: [Announcement]?)
}

public class BulletinData: NSObject {

    var postDayCount : Int
    var birthdays: [String]?
    var bulletinData: [DailyBulletinData]?
    var delegate: AnyObject?
    
    public init(postDayCount: Int) {
        self.postDayCount = postDayCount
        bulletinData = nil
        super.init()
    }
    
    public func parseHTMLData(hpple: TFHpple?){
        
        let allPosts = hpple?.search(withXPathQuery: "//div[@class='posts']")
        for index in 0...self.postDayCount {
            
            let dailyElement = allPosts?[index] as!TFHppleElement
            
            let data = dailyElement.search(withXPathQuery: "//ul[@class='posts-list daily-posts']/li") as! [TFHppleElement]
            
            //parse out all the posts for one day
            let bulletinData = self.parseBulletinPosts(posts: data)
            let dailyData = DailyBulletinData.init(posts: bulletinData?.posts, announcements: bulletinData?.announcement, menu: nil)
            
            self.bulletinData?.append(dailyData)
        }
    }
    
    public func parseBulletinPosts(posts: [TFHppleElement]) -> (posts: [Post], announcement: [Announcement])? {
        
        // * This method parses out all the post for one day *
        // return a list of bulletin posts for this day
        
        var pts = [Post]()
        var announcements = [Announcement]()
        
        for element in posts {

            //get image src
            let imgs = element.search(withXPathQuery:"//a[@data-lightbox='gallerySet']") as! [TFHppleElement]
            
            let imgSrc = imgs.first?.attributes["href"]

            let link = element.firstChild(withTagName: "div").firstChild(withTagName: "a").attributes["href"]
            
            //search for title of post
            let titles = element.search(withXPathQuery: "//h2[@class='summary-title']") as! [TFHppleElement]
            let title = BulletinDataHelper.cleanString(string: (titles.first?.text())!)
            
            let summeries = element.search(withXPathQuery: "//p[@class='summary-excerpt']") as! [TFHppleElement]
            let summery = BulletinDataHelper.cleanString(string: (summeries.first?.text())!)
            
            let postType = "parseBulletinPosts"
            if link != nil {
                let post = Post.init(image: imgSrc as! String,
                                     title: title,
                                     postDescription: summery,
                                     postLink: link as! String,
                                     postType: postType)
                pts.append(post)
//                if imgSrc != nil {
//
//                }else{
//                    let announcement = Announcement.init(title: title, description: summery, postLink: link as! String)
//                    announcements.append(announcement)
//                }
            }
        }
        
        return (pts, announcements)
    }
    
    public func parseBirthdays(birthdays: [Any]) -> [String]? {
        return nil
    }
    
    public func retrieveHTMLData() {
        
        let session = URLSession.shared;
        let url = URL.init(string: "https://deerfield.edu/bulletin")
        let urlRequest = URLRequest.init(url: url!)
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if (error == nil){
                DispatchQueue.main.async {
                    let hpple = TFHpple.init(htmlData: data)
                    self.parseHTMLData(hpple: hpple!)
                }
            }else{
                print(error!)
            }
        }
        dataTask.resume()
    }
}
