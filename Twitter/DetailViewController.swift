//
//  DetailViewController.swift
//  Twitter
//
//  Created by Jiayi Kou on 2/16/16.
//  Copyright © 2016 Jiayi Kou. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var tweet:Tweet!
    var followersCount: NSNumber?
    var followingCount: NSNumber?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var twittertextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetnoLabel: UILabel!
    @IBOutlet weak var likenoLabel: UILabel!
    
    @IBOutlet weak var imageButton: UIButton!
    @IBAction func onRetweet(sender: AnyObject) {
        if tweet!.retweeted! {
            TwitterClient.sharedInstance.unretweet((tweet?.id)!, completion: { (response, error) -> () in
                self.tweet?.retweeted = false
            })
            
        } else {
            TwitterClient.sharedInstance.retweet((tweet?.id)!) { (response, error) -> () in
                self.tweet?.retweeted = true
                self.tweet?.retweetCount = (self.tweet?.retweetCount?.integerValue)! + 1
                
                
            }
        }

        
    }
    @IBAction func onLike(sender: AnyObject) {
        
        if tweet!.liked! {
            TwitterClient.sharedInstance.unLike((tweet?.id)!, completion: { (response, error) -> () in
                self.tweet!.liked = false
            })
            
        } else {
            TwitterClient.sharedInstance.like((tweet?.id)!) { (response, error) -> () in
                self.tweet!.liked = true
                self.tweet?.likeCount = (self.tweet?.likeCount?.integerValue)! + 1
            }
        }

        
    }
    @IBAction func onReply(sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let tweet = tweet {
            let user = tweet.user
            self.usernameLabel.text = user?.name
            self.usernameLabel.sizeToFit()
            self.profileImageView.setImageWithURL(NSURL(string: (user?.profileImageUrl)!)!)
            self.twittertextLabel.text = tweet.text
            self.tweetnoLabel.text = tweet.retweetCount?.stringValue
            self.likenoLabel.text = tweet.likeCount?.stringValue
            let time = Int((tweet.createdAt?.timeIntervalSinceNow)!)
            if (-time/3600) == 0 {
                self.timeLabel.text = "\(-time/60)m"
            } else {
                self.timeLabel.text = "\(-time/3600)h"
            }
        }
        
        twittertextLabel.sizeToFit()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "profile" {
        let cell = sender as! UIButton
        let tweet = self.tweet
        let destinationViewController = segue.destinationViewController as! ProfileViewController
        destinationViewController.tweet = tweet
        }else{
            let cell = sender as! UIButton
            let tweet = self.tweet
            let destinationViewController = segue.destinationViewController as! ComposeViewController
            destinationViewController.tweet = tweet
        }

    }
    

}
