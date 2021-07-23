//
//  TabBarController.swift
//  Instagram
//
//  Created by イイダカオリ on 2021/07/22.
//

import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
