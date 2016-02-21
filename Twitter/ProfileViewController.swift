//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Jiayi Kou on 2/21/16.
//  Copyright © 2016 Jiayi Kou. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tweetNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var followerNumberLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    var tweet:Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tweet = tweet {
            let user = tweet.user
            self.usernameLabel.text = user?.name
            self.usernameLabel.sizeToFit()
            self.profileImageView.setImageWithURL(NSURL(string: (user?.profileImageUrl)!)!)
            self.tweetNumberLabel.text = tweet.retweetCount?.stringValue
           self.followerNumberLabel.text = user?.follower?.stringValue
            self.followingNumberLabel.text = user?.following?.stringValue
        }
        usernameLabel.sizeToFit()
        tweetNumberLabel.sizeToFit()
        followingNumberLabel.sizeToFit()
        followerNumberLabel.sizeToFit()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
