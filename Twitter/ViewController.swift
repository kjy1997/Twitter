//
//  ViewController.swift
//  Twitter
//
//  Created by Jiayi Kou on 2/8/16.
//  Copyright © 2016 Jiayi Kou. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController{

    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if (user != nil) {
                //perform my segue
                self.performSegueWithIdentifier("pushToTwitter", sender: self)
            } else {
                // handle login error
                self.errorLabel.text = "\(error)"
            }
        }
    }

}

