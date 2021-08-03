//
//  PostData.swift
//  Instagram
//
//  Created by イイダカオリ on 2021/07/26.
//

import UIKit
import Firebase

class PostData: NSObject{
    var id: String
    var name: String?
    var comments: [String] = []
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(document: QueryDocumentSnapshot){
        self.id = document.documentID
        
        let postDic = document.data()
        
        self.name = postDic["name"] as? String
        
        if let comments = postDic["comments"] as? [String]{
            self.comments = comments
        }
       
        self.caption = postDic["caption"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String]{
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid{
            //Likesの配列の中にmyidが含まれるかチェックすることで自分がいいねを押してるか判断する
            if self.likes.firstIndex(of: myid) != nil {
                //myidがあればいいねを押していると判断する
                self.isLiked = true
            }
        }
    }
}
