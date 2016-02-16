
import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?
    @IBOutlet weak var tableView: UITableView!
        override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImageView(image: UIImage(named: "Twitter_logo"))
        self.navigationItem.titleView = image
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // Do any additional setup after loading the view
        
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        if let tweets = tweets {
            let tweet = tweets[indexPath.row]
            let user = tweet.user
            cell.usernameLabel.text = user?.name
            cell.profileimageView.setImageWithURL(NSURL(string: (user?.profileImageUrl)!)!)
            cell.tweettextLabel.text = tweet.text
            
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
