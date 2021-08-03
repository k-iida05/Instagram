//
//  commentViewController.swift
//  Instagram
//
//  Created by イイダカオリ on 2021/07/26.
//

import UIKit
import Firebase
import SVProgressHUD

class commentViewController: UIViewController {
    

    @IBOutlet weak var commentTextField: UITextField!
    
    
    var postArray: [PostData] = []
    var postData: PostData?
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleCommentButton(_ sender: Any) {
      
        if let comment = commentTextField.text{
            if  comment.isEmpty {
                SVProgressHUD.showError(withStatus: "コメントを入力してください。")
                return
            }
        }
        let name = Auth.auth().currentUser?.displayName
        let comment = "\(name!):\(commentTextField.text!)"
        let updateValue = FieldValue.arrayUnion([comment])
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData!.id)
        postRef.updateData(["comments": updateValue])
    
       SVProgressHUD.showSuccess(withStatus: "コメントしました")

        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
