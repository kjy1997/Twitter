//
//  PostsViewController.swift
//  Twitter
//
//  Created by Jiayi Kou on 2/14/16.
//  Copyright © 2016 Jiayi Kou. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    func tweetsWithArray(array: [NSDictionary]) -> [Tweet]{
        for dictionary in array {
            self.tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
   
    @IBAction func onSignOut(sender: AnyObject) {
        User.currentUser?.logout()
    }
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        if let tweets = tweets {
            let tweet = tweets[indexPath.row]
            let user = tweet.user
            cell.usernameLabel.text = user?.name
            cell.usernameLabel.sizeToFit()
            cell.profileimageView.setImageWithURL(NSURL(string: (user?.profileImageUrl)!)!)
            cell.tweettextLabel.text = tweet.text
            cell.tweetCount.text = tweet.retweetCount?.stringValue
            cell.likeCount.text = tweet.likeCount?.stringValue
            let time = Int((tweet.createdAt?.timeIntervalSinceNow)!)
            if (-time/3600) == 0 {
                cell.timestampLabel.text = "\(-time/60)m"
            } else {
                cell.timestampLabel.text = "\(-time/3600)h"
            }
            
            if tweet.retweeted! {
                cell.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
            } else {
                cell.retweetButton.setImage(UIImage(named: "retweet-action"), forState: .Normal)
            }
            
            if  tweet.liked! {
                cell.likeButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
            } else {
                cell.likeButton.setImage(UIImage(named: "like-action"), forState: .Normal)
            }
            
            
            cell.tweet = tweet
       }
        
        cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
        return cell

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let tweet = tweets[(indexPath?.row)!]
        let destinationViewController = segue.destinationViewController as! DetailViewController
        destinationViewController.tweet = tweet
        
    }
}
