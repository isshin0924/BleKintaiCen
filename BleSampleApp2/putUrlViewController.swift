//
//  putUrlViewController.swift
//  BleSampleApp2
//
//  Created by ISSHIN on 30/11/2016.
//  Copyright © 2016 ISSHIN. All rights reserved.
//

import UIKit

class putUrlViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var urlEnt: UITextField!
    @IBOutlet weak var hoge: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = UIColor.orange
        view.backgroundColor = UIColor.white
        print("hoge")
    }
    

    @IBAction func pushStart(_ sender: Any) {
        var testText = urlEnt.text!
        
        // 遷移するViewを定義する.
        let secondViewController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "view") as! ViewController
        // Viewの移動する.
        //self.present(putViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //UserDefaultに保存
        //ユーザーデフォルトを用意する
                var myDefault = UserDefaults.standard
        
                //データを書き込んで
                myDefault.set(testText, forKey: "url")
        
                //即反映させる
                myDefault.synchronize()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
