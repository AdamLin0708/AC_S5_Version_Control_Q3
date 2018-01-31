//
//  Movie.swift
//  Movies
//
//  Created by Brian Hu on 7/5/16.
//  Copyright © 2016 AlphaCamp. All rights reserved.
//

import UIKit

class Movie {
    var image: UIImage?
    let name: String
    let description: String
    
    static let latestMovies = [
        Movie(imageName: "TheConjuring2", name: "The Conjuring 2", description: "Lorraine and Ed Warren travel to north London to help a single mother raising four children alone in a house plagued by a malicious spirit."),
        Movie(imageName: "MikeAndDave", name: "Mike and Dave Need Wedding Dates", description: "Two brothers place an online ad to find dates for a wedding and the ad goes viral."),
        Movie(imageName: "CivilWar", name: "Captain America: Civil War", description: "Political interference in the Avengers' activities causes a rift between former allies Captain America and Iron Man.")
        ]
    
    init(imageName: String, name: String, description: String) {
        self.image = UIImage(named: imageName)
        self.name = name
        self.description = description
    }
}
