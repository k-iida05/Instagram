//
//  HomeViewController.swift
//  Instagram
//
//  Created by イイダカオリ on 2021/07/22.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    //投稿データを格納する配列
    var postArray: [PostData] = []
    //Firestoreのリスナー
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib,forCellReuseIdentifier:"Cell")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        //ログイン済みか確認
        if Auth.auth().currentUser != nil {
            //listenerを登録して投稿データの更新を監視する
            let postRef = Firestore.firestore().collection(Const.PostPath).order(by:"date",descending: true)
            listener = postRef.addSnapshotListener(){(querySnapshot,error) in
                if let error = error{
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。\(error)")
                    return
                }
                //取得したdocumentを元にpostdataを作成しpostArrayに配列する
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得\(document.documentID)")
                    let postData = PostData(document: document)
                    return postData
                }
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        //listenerを削除して監視を停止
        listener?.remove()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        cell.commentButton.addTarget(self, action: #selector(handleCommentButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func handleButton(_ sender:UIButton,forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            //更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                //すでにいいねをしている場合はいいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                //今回新たにいいねを押した場合はmyidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            //likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes":updateValue])
        }
    }
    
    
    @objc func handleCommentButton(_ sender:UIButton,forEvent event: UIEvent) {
        print("DEBUG_PRINT: commentボタンがタップされました。")
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! commentViewController
        commentVC.postData = postData
        present(commentVC, animated: true, completion: nil)

    }
    
}

