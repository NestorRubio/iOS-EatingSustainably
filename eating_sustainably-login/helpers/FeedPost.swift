//
//  FeedPost.swift
//  eating_sustainably-login
//
//  Created by user190188 on 5/17/21.
//

import Foundation

class FeedPost{
    
    var author : String
    var content : String
    var likes : Int
    
    init(author : String, content : String, likes : Int) {
        self.author = author
        self.content = content
        self.likes = likes
    }
}
