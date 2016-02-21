//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Jiayi Kou on 2/21/16.
//  Copyright © 2016 Jiayi Kou. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    
    var tweet:Tweet!
    @IBOutlet weak var tweetTextField: UITextField!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tweet = tweet {
            let user = tweet.user
            self.usernameLabel.text = user?.name
            self.usernameLabel.sizeToFit()
            self.profileImageView.setImageWithURL(NSURL(string: (user?.profileImageUrl)!)!)
            self.screennameLabel.text = user?.screenName
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func onCancel(sender: AnyObject) {
        
    }
    @IBAction func onTweet(sender: AnyObject) {
        
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
        let cell = sender as! UIBarButtonItem
        let tweet = self.tweet
        let destinationViewController = segue.destinationViewController as! DetailViewController
        destinationViewController.tweet = tweet

    }
    

}
