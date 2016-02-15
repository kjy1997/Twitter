//
//  Tweet.swift
//  Twitter
//
//  Created by Jiayi Kou on 2/14/16.
//  Copyright © 2016 Jiayi Kou. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "OiS2HOo2YYCYl9CvzyyscWZfG"
let twitterConsumerSecret = "uYIv7BMvCNHy3WojnrCXuTG1XlEHQh26EHMruJxbs8jomQXQAx"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

var loginCompletion: ((user: User?, error: NSError?) -> ())?


class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                
                print("Failed to get request token")
        }
    }
    
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            print("got timeline")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error)
                completion(tweets: nil, error: error)
        })
        
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
                             var user = User(dictionary: response as! NSDictionary)
                print("user: \(user.name)")
                TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                                      var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                    
                    for tweet in tweets {
                        print("text: \(tweet.text), created: \(tweet.createdAt)")
                    }
                    
                    }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                        print("error getting home_timeline")
                })
                
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("error getting current user")
            })
            }) { (error: NSError!) -> Void in
                print("failed to receive access token")
            }
    }
}



