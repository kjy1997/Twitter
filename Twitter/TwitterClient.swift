

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "5GCekZZ8XOozM2Z4S116zaYsu"
let twitterConsumerSecret = "IvFYuA4LMkqo0pXVzepFqCnWx9EzraTxjr5hyOV3N5cZExUBmj"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")




class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print(response)
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            print("got timeline")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error)
                completion(tweets: nil, error: error)
        })
        
    }
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("got the equest token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error)
                print("failed to get request token")
        }
    }
    
    
    func retweet(ID: String, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        POST("https://api.twitter.com/1.1/statuses/retweet/\(ID).json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            completion(response: response as? NSDictionary, error: nil)
            print("retweeted")
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(response: nil, error: error)
                print("error retweeting")
                print(error)
        }
        
    }
    
    func unretweet(ID: String, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        POST("https://api.twitter.com/1.1/statuses/unretweet/\(ID).json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            completion(response: response as? NSDictionary, error: nil)
            print("unretweeted")
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(response: nil, error: error)
                print("error unretweet")
        }
        
    }
    
    func like(ID: String, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        let parameters = NSMutableDictionary()
        parameters["id"] = ID
        
        POST("1.1/favorites/create.json", parameters: parameters, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("liked")
            completion(response: response as? NSDictionary, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error liking")
                print(error)
                completion(response: nil, error: error)
        })
        
    }
    
    func unLike(ID: String, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        let parameters = NSMutableDictionary()
        parameters["id"] = ID
        
        POST("1.1/favorites/destroy.json", parameters: parameters, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("unliked")
            completion(response: response as? NSDictionary, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error unliking")
                print(error)
                completion(response: nil, error: error)
        })
        
    }
    
    
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token")
            
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                //print("user:\(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    self.loginCompletion?(user: nil, error: error)
                    print("error getting current user")
            })
            }) { (error: NSError!) -> Void in
                print("failed to recieve access token")
                //              self.loginWithCompletion(user: nil, error: error)
                self.loginCompletion?(user: nil, error: error)
        }
    }
}



