//
//  FeedPost.swift
//  eating_sustainably-login
//
//  Created by user190188 on 5/17/21.
//

import Foundation
import FirebaseFirestore

class FeedPost{
    
    var author : String
    var content : String
    var likes : Int
    var timeStamp : Date
    
    init(author : String, content : String, likes : Int, timeStamp: Date) {
        self.author = author
        self.content = content
        self.likes = likes
        self.timeStamp = timeStamp
    }
    
    init(withDoc: QueryDocumentSnapshot) {
                
                self.author = withDoc.get("name") as? String ?? "no name"
                self.content = withDoc.get("post") as? String ?? "no post"
                self.likes = withDoc.get("likes") as? Int ?? 0
                self.timeStamp = withDoc.get("timestamp") as? Date ?? Date()
            }
}
