//
//  DetailViewController.swift
//  Movies
//
//  Created by Brian Hu on 7/5/16.
//  Copyright © 2016 AlphaCamp. All rights reserved.
//

import UIKit
import FBSDKShareKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movie: Movie?
    
    @IBOutlet weak var FBShareButton: FBSDKShareButton!
    
    @IBOutlet weak var FBSendButton: FBSDKSendButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        movieImageView.image = movie?.image
        nameLabel.text = movie?.name
        descriptionLabel.text = movie?.description
        
        self.title = movie?.name
        
        let content = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "http://stackoverflow.com/questions/26045666/facebook-share-dialog-doesnt-work-when-href-parameter-is-a-variable")
        content.contentTitle = movie?.name
        content.contentDescription = movie?.description
        self.FBShareButton.shareContent = content
        self.FBSendButton.shareContent = content
        if !self.FBSendButton.enabled {
            print("user doesn't install the messenger app!")
            self.FBSendButton.hidden = true
        }
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
    }

}
