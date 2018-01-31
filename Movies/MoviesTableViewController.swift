//
//  MoviesTableViewController.swift
//  Movies
//
//  Created by Brian Hu on 7/5/16.
//  Copyright © 2016 AlphaCamp. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MoviesTableViewController: UITableViewController {
    
    // TODO: 1. declaring the following properties
    var ref: FIRDatabaseReference!
    private var _refHandle: FIRDatabaseHandle!
    var movies: [FIRDataSnapshot]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "MyMovieTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "My Movie Cell")
        
        tableView.estimatedRowHeight = 80
        
        // TODO: 2. connect to database
        configureDatabase()
    }
    
    // TODO: 3. remove the observer in deinit
    deinit {
        self.ref.child("movies").removeObserverWithHandle(_refHandle)
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        if let user = FIRAuth.auth()?.currentUser {
            _refHandle = self.ref.child("movies").queryOrderedByChild("createdBy").queryEqualToValue(user.uid).observeEventType(.ChildAdded, withBlock: { (snapshot) in
                    self.movies.append(snapshot)
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.movies.count-1, inSection: 0)], withRowAnimation: .Automatic)
            })
        } else {
            _refHandle = self.ref.child("movies").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
                self.movies.append(snapshot)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.movies.count-1, inSection: 0)], withRowAnimation: .Automatic)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: 4. read movies from FB for section 0,
        switch section {
        case 0:
            return movies.count
        default:
            return Movie.latestMovies.count
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return UITableViewAutomaticDimension
        default:
            return 60
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.width

        let label = UILabel(frame: CGRectMake(0, 0, screenWidth, 35))
        header.backgroundColor = UIColor.lightGrayColor()
        
        if section == 0 {
            label.text = "Standard Cells"
        } else if section == 1 {
            label.text = "Custom Cells"
        }

        header.addSubview(label)
        return header
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            // TODO: 5. set cell accrodingly
            let cell = tableView.dequeueReusableCellWithIdentifier("Movie Cell", forIndexPath: indexPath)
            let movieSnapshot: FIRDataSnapshot! = self.movies[indexPath.row]
            let movie = movieSnapshot.value as! Dictionary<String, String>
            let name = movie["name"] as String!
            let imageName = movie["imageName"] as String!
            cell.textLabel?.text = name
            cell.imageView?.image = UIImage(named: imageName)
            return cell
        case 1:
            let movie = Movie.latestMovies[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("My Movie Cell", forIndexPath: indexPath) as! MyMovieTableViewCell
            
            cell.movieImageView.image = movie.image
            cell.nameLabel.text = movie.name
            cell.descriptionLabel.text = movie.description
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            let movie = movies[indexPath.row]
            self.performSegueWithIdentifier("Movies Table To Detail", sender: movie)
        default:
            let movie = Movie.latestMovies[indexPath.row]
            self.performSegueWithIdentifier("Movies Table To Detail", sender: movie)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Movies Table To Detail" {
            let detailVC = segue.destinationViewController as! DetailViewController
            if let movieInfo = sender {
                if movieInfo.isKindOfClass(Movie) {
                    detailVC.movie = movieInfo as? Movie
                } else if movieInfo.isKindOfClass(FIRDataSnapshot) {
                    let movieSnapshot = movieInfo as! FIRDataSnapshot
                    let movieSnapshotValue = movieSnapshot.value as! Dictionary<String, String>
                    let movie = Movie(imageName: movieSnapshotValue["imageName"]!, name: movieSnapshotValue["name"]!, description: movieSnapshotValue["description"]!)
                    detailVC.movie = movie
                }
            }

        }
    }
}
