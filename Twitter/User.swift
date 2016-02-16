

import UIKit

var _currentUser: User?
let currentUserKey = "CurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"


class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        
        
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        
    }
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
        let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if let data = data {
        let dictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
        _currentUser = User(dictionary: dictionary)
        
        }
        
        }
        
        
        
        return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                
                let data = try! NSJSONSerialization.dataWithJSONObject((user!.dictionary), options: [])
                
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                
            }
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
}







