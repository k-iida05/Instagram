//
//  TabBarController.swift
//  Instagram
//
//  Created by イイダカオリ on 2021/07/22.
//

import UIKit
import Firebase

class TabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            // currentUserがnilならログインしていない
            if Auth.auth().currentUser == nil {
                // ログインしていないときの処理
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(loginViewController!, animated: true, completion: nil)
            }
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //アイコンの色
        self.tabBar.tintColor = UIColor(red:1.0,green: 0.44,blue: 0.11,alpha: 1)
        //タブバー背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        self.delegate = self

        // Do any additional setup after loading the view.
    }
    //タブバーのアイコンが押された時
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //imageSelectVCはモーダル遷移する
        if viewController is ImageSelectViewController{
            let imageSelectVC = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            present(imageSelectVC,animated: true)
            return false
        }else{
            return true
        }
    }
 

}
