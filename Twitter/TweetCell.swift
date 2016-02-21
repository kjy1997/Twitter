//
//  TweetCell.swift
//  Twitter
//
//  Created by Jiayi Kou on 2/14/16.
//  Copyright © 2016 Jiayi Kou. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileimageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweettextLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    var tweet: Tweet?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
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
}
