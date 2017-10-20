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
            
            //parse out this day's birthdays
            let bddata = dailyElement.search(withXPathQuery: "//div[@class='content-summary-badge daily birthday']")
            let bdays = self.parseBirthdays(birthdays: bddata!)
            
            //parse out all the posts
            let bulletinData = self.parseBulletinData(posts: data)
            let dailyData = DailyBulletinData.init(posts: bulletinData?.posts, announcements: bulletinData?.announcement, menu: nil, birthdays: bdays)
            
            self.bulletinData?.append(dailyData)
        }
    }
    
    public func parseBulletinData(posts: [TFHppleElement]) -> (posts: [Post], announcement: [Announcement])? {
        
        var pts = [Post]()
        var announcements = [Announcement]()
        
        for element in posts {

            //get image src
            let imgs = element.search(withXPathQuery:"//a[@data-lightbox='gallerySet']") as! [TFHppleElement]
            
            let imgSrc = imgs.first?.attributes["href"]

            let link = element.firstChild(withTagName: "div").firstChild(withTagName: "a").attributes["href"]
            
            //search for title of post
            let titles = element.search(withXPathQuery: "//h2[@class='summary-title']") as! [TFHppleElement]
            let title = self.cleanString(string: (titles.first?.text())!)
            
            let summeries = element.search(withXPathQuery: "//p[@class='summary-excerpt']") as! [TFHppleElement]
            let summery = self.cleanString(string: (summeries.first?.text())!)
            
            if link != nil {
                if imgSrc != nil {
                    let post = Post.init(image: imgSrc as! String, title: title, postDescription: summery, postLink: link as! String)
                    pts.append(post)
                }else{
                    let announcement = Announcement.init(title: title, description: summery, postLink: link as! String)
                    announcements.append(announcement)
                }
            }
        }
        
        return (pts, announcements)
    }
    
    private func cleanString(string: String) -> String {
        var str = string
        str = (str as NSString).replacingOccurrences(of: "\n", with: "")
        str = (str as NSString).replacingOccurrences(of: "\t", with: "")
        return str as String
    }
    
    public func parseBirthdays(birthdays: [Any]) -> [String]? {
        return nil
    }
    
    public func retrieveHTMLData() {
        
//        let configeration = URLSessionConfiguration.default
//        let manager = AFURLSessionManager.init(sessionConfiguration: configeration)
//
//        let url = URL.init(string: "https://deerfield.edu/bulletin")
//        let request = URLRequest.init(url: url!)
//
//        let downloadTask = manager.downloadTask(with: request, progress: nil, destination: { (targetPath, response) -> URL in
//
//            var documentsDirectoryURL = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
//            documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent(response.suggestedFilename!)
//            if (FileManager.default.fileExists(atPath: documentsDirectoryURL.path)){
//                try! FileManager.default.removeItem(atPath: documentsDirectoryURL.path)
//            }
//            return documentsDirectoryURL
//
//        }) { (response, filepath, error) in
//
//            if (error == nil){
//                DispatchQueue.main.async {
//                    let hpple = TFHpple.init(htmlData: try! Data.init(contentsOf: filepath!))
//                    self.parseHTMLData(hpple: hpple!)
//                }
//            }else{
//                print(error!)
//            }
//        }
//        downloadTask.resume()
    }
}
