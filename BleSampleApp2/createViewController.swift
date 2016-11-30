//
//  createViewController.swift
//  BleSampleApp2
//
//  Created by ISSHIN on 30/11/2016.
//  Copyright © 2016 ISSHIN. All rights reserved.
//
import UIKit

class createViewController: UIViewController, UIWebViewDelegate  {
    
    let webView : UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate設定
        webView.delegate = self
        
        // Webページの大きさを画面に合わせる
        let rect:CGRect = self.view.frame
        webView.frame = rect
        webView.scalesPageToFit = true
        
        // インスタンスをビューに追加する
        self.view.addSubview(webView)
        
        // URLを指定
        let url: URL = URL(string: "https://www.google.com/forms/about/")!
        let request: URLRequest = URLRequest(url: url)
        
        // リクエストを投げる
        webView.loadRequest(request)
        
    }
    
    
    // ロード時にインジケータをまわす
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("indicator on")
    }
    
    // ロード完了でインジケータ非表示
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("indicator off")
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
