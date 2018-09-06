//
//  BulletinData.swift
//  
//
//  Created by Yongyang Nie on 9/13/17.
//

import UIKit

@objc public protocol BulletinDataDelegate {
    
    // func recievedNewData(posts: [Post]?, announcements: [Announcement]?)
    func finishLoadingData()
    func finishLoadingData(refresh: UIRefreshControl)
    // oops, we have issues
    func bulletinDataLoadingError(error: Error)
}

public class BulletinData: NSObject{
    
    @objc public var dayCount : Int
    @objc public var birthdays: [String]?
    @objc public var bulletinData: [DailyBulletinData]? // the bulletin data comprises of many dailyBulletinDatas
    @objc public var delegate: BulletinDataDelegate?
    @objc public var htmlData: TFHpple?
    
    @objc public init(postDayCount: Int) {
        
        self.dayCount = postDayCount
        bulletinData = [DailyBulletinData]()
        super.init()
    }
    
    @objc private func parseHTMLData(hpple: TFHpple?){
        
        let dailyBlocks = hpple?.search(withXPathQuery: "//div[@class='content-block daily']")
        
        for index in 0...self.dayCount - 1 {
            
            let dailyElement = dailyBlocks?[index] as! TFHppleElement
            
            let data = dailyElement.search(withXPathQuery: "//ul[@class='posts-list daily-posts']/li") as! [TFHppleElement]
            
            //parse out all the posts for one day
            // get date
            let dateString = BulletinDataHelper.cleanString(string: ((dailyElement.search(withXPathQuery: "//div[@class='title']") as! [TFHppleElement]).first?.content)!)
            let date : Date;
            if dateString == "Yesterday" {
                date = Date().yesterday
            }else if dateString == "Today" {
                date = Date()
            }else{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM yyyy"
                date = dateFormatter.date(from:dateString)!
            }
            
            let bulletinData = self.parseBulletinPosts(posts: data, date: date)
            let dailyData = DailyBulletinData.init(posts: bulletinData, announcements: nil, menu: nil, date: dateString)
            
            self.bulletinData?.append(dailyData)
        }
    }
    
    @objc public func parseBulletinPosts(posts: [TFHppleElement], date: Date) -> [Post]? {
        
        // * This method parses out all the post for one day *
        // return a list of bulletin posts for this day
        
        var pts = [Post]()
        // var announcements = [Announcement]()

        for element in posts {
            
            // the content must be a post
            if element.attributes.values.description.range(of:"posts") != nil {
                
                // get image src
                let imgs = element.search(withXPathQuery:"//a[@data-lightbox='gallerySet']") as! [TFHppleElement]
                var imgSrc = imgs.first?.attributes["href"]
                imgSrc = getPostImage(url: imgSrc as? String)
                
                let link = element.firstChild(withTagName: "div").firstChild(withTagName: "a").attributes["href"]
                
                // search for title of post
                let titles = element.search(withXPathQuery: "//h2[@class='summary-title']") as! [TFHppleElement]
                let title = BulletinDataHelper.cleanString(string: (titles.first?.text())!)
                
                let summeries = element.search(withXPathQuery: "//p[@class='summary-excerpt']") as! [TFHppleElement]
                let summery = BulletinDataHelper.cleanString(string: (summeries.first?.text())!)
                
                // figure out the post type
                let postType : PostType
                
                if element.attributes.values.description.range(of: "lost-and-found") != nil{
                    postType = PostType.LostFound
                }else if element.attributes.values.description.range(of: "athletic-news") != nil {
                    postType = PostType.Athletics
                }else if element.attributes.values.description.range(of: "student-news") != nil {
                    postType = PostType.StudentNews
                }else{
                    postType = PostType.None
                }
                
                if link != nil {
                    let post = Post.init(date: date, image: imgSrc as! String, title: title, postDescription: summery, postLink: link as! String, postType: postType)
                    pts.append(post)
                }
            }
        }
        return pts
    }

    
    @objc public func retrieveHTMLData() {
        
        let session = URLSession.shared;
        let url = URL.init(string: "https://deerfield.edu/bulletin")
        let urlRequest = URLRequest.init(url: url!)
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if (error == nil){
                DispatchQueue.main.async {
                    let hpple = TFHpple.init(htmlData: data)
                    self.htmlData = hpple!
                    self.parseHTMLData(hpple: hpple!)
                    self.delegate?.finishLoadingData()
                }
            }else{
                self.delegate?.bulletinDataLoadingError(error: error!)
            }
        }
        dataTask.resume()
    }
    
    @objc public func retrieveHTMLData(refresh: UIRefreshControl) {
        
        let session = URLSession.shared;
        let url = URL.init(string: "https://deerfield.edu/bulletin")
        let urlRequest = URLRequest.init(url: url!)
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if (error == nil){
                DispatchQueue.main.async {
                    let hpple = TFHpple.init(htmlData: data)
                    self.htmlData = hpple!
                    self.parseHTMLData(hpple: hpple!)
                    self.delegate?.finishLoadingData(refresh: refresh)
                }
            }else{
                self.delegate?.bulletinDataLoadingError(error: error!)
            }
        }
        dataTask.resume()
    }
    
    func getPostImage(url: String?) -> String{
    
        if (url != nil){
            return url!;
        }else{
            let i = arc4random_uniform(6);
            return String.init(format: "ph_\(i).jpg")
        }
    }
}
