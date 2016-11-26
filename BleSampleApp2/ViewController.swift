//
//
//  ViewController.swift
//  CoreLocation002
//
//  Copyright © 2016年 FaBo, Inc. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate,UIWebViewDelegate{
    
    var myLocationManager:CLLocationManager!
    var myBeaconRegion:CLBeaconRegion!
    var beaconUuids: NSMutableArray!
    var beaconDetails: NSMutableArray!
    @IBOutlet weak var webview: UIWebView!
    // 今回の検知対象は3つのUUID。(OS等のバージョンで検出可能な上限数は20個程度が目安)
    let UUIDList = [
        "9EDFA660-204E-4066-8644-A432AE2B6EC1",
        "9EDFA660-204E-4066-8644-A432AE2B6EC2",
        "9EDFA660-204E-4066-8644-A432AE2B6EC3"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ロケーションマネージャの作成.
        myLocationManager = CLLocationManager()
        
        // デリゲートを自身に設定.
        myLocationManager.delegate = self
        
        // 取得精度の設定.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 取得頻度の設定.(1mごとに位置情報取得)
        myLocationManager.distanceFilter = 1
        
        // セキュリティ認証のステータスを取得
        let status = CLLocationManager.authorizationStatus()
        ////print("CLAuthorizedStatus: \(status.rawValue)");
        
        // まだ認証が得られていない場合は、認証ダイアログを表示
        if(status == .notDetermined) {
            // [認証手順1] まだ承認が得られていない場合は、認証ダイアログを表示.
            // [認証手順2] が呼び出される
            myLocationManager.requestAlwaysAuthorization()
        }
        
        // 配列をリセット
        beaconUuids = NSMutableArray()
        beaconDetails = NSMutableArray()
    }
    
    /*
     CoreLocationの利用許可が取れたらiBeaconの検出を開始する.
     */
    private func startMyMonitoring() {
        
        // UUIDListのUUIDを設定して、反応するようにする
        for i in 0 ..< UUIDList.count {
            
            // BeaconのUUIDを設定.
            let uuid: NSUUID! = NSUUID(uuidString: "\(UUIDList[i].lowercased())")
            
            // BeaconのIfentifierを設定.
            let identifierStr: String = "fabo\(i)"
            
            // リージョンを作成.
            myBeaconRegion = CLBeaconRegion(proximityUUID: uuid as UUID, identifier: identifierStr)
            
            // ディスプレイがOffでもイベントが通知されるように設定(trueにするとディスプレイがOnの時だけ反応).
            myBeaconRegion.notifyEntryStateOnDisplay = false
            
            // 入域通知の設定.
            myBeaconRegion.notifyOnEntry = true
            
            // 退域通知の設定.
            myBeaconRegion.notifyOnExit = true
            
            // [iBeacon 手順1] iBeaconのモニタリング開始([iBeacon 手順2]がDelegateで呼び出される).
            myLocationManager.startMonitoring(for: myBeaconRegion)
        }
    }
    
    /*
     [認証手順2] 認証のステータスがかわったら呼び出される.
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //print("didChangeAuthorizationStatus");
        
        // 認証のステータスをログで表示
        switch (status) {
        case .notDetermined:
            //print("未認証の状態")
            break
        case .restricted:
            //print("制限された状態")
            break
        case .denied:
            //print("許可しない")
            break
        case .authorizedAlways:
            //print("常に許可")
            // 許可がある場合はiBeacon検出を開始.
            startMyMonitoring()
            break
        case .authorizedWhenInUse:
            //print("このAppの使用中のみ許可")
            // 許可がある場合はiBeacon検出を開始.
            startMyMonitoring()
            break
        }
    }
    
    /*
     [iBeacon 手順2]  startMyMonitoring()内のでstartMonitoringForRegionが正常に開始されると呼び出される。
     */
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
        //print("[iBeacon 手順2] didStartMonitoringForRegion");
        
        // [iBeacon 手順3] この時点でビーコンがすでにRegion内に入っている可能性があるので、その問い合わせを行う
        // [iBeacon 手順4] がDelegateで呼び出される.
        manager.requestState(for: region);
    }
    
    /*
     [iBeacon 手順4] 現在リージョン内にiBeaconが存在するかどうかの通知を受け取る.
     */
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        //print("[iBeacon 手順4] locationManager: didDetermineState \(state)")
        
        switch (state) {
            
        case .inside: // リージョン内にiBeaconが存在いる
            print("iBeaconが存在!");
            // [iBeacon 手順5] すでに入っている場合は、そのままiBeaconのRangingをスタートさせる。
            // [iBeacon 手順6] がDelegateで呼び出される.
            // iBeaconがなくなったら、Rangingを停止する
            //Delegateを設定
            webview.delegate = self
            
            // WebViewのサイズを設定.
            webview.frame = self.view.bounds
            
            // URLを設定.
            let url: URL = URL(string: "https://goo.gl/forms/9Ln735HtnOKnpi6J3")!
            
            // リエストを発行する.
            let request: NSURLRequest = NSURLRequest(url: url)
            
            // リクエストを発行する.
            webview.loadRequest(request as URLRequest)

            manager.startRangingBeacons(in: region as! CLBeaconRegion)
            break;
            
        case .outside:
            print("iBeaconが圏外!")
            // 外にいる、またはUknownの場合はdidEnterRegionが適切な範囲内に入った時に呼ばれるため処理なし。
            break;
            
        case .unknown:
            print("iBeaconが圏外もしくは不明な状態!")
            // 外にいる、またはUknownの場合はdidEnterRegionが適切な範囲内に入った時に呼ばれるため処理なし。
            break;
            
        }
    }
    
    /*
     [iBeacon 手順6] 現在取得しているiBeacon情報一覧が取得できる.
     iBeaconを検出していなくても1秒ごとに呼ばれる.
     */
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    }
    
    /*
     [iBeacon イベント] iBeaconを検出した際に呼ばれる.
     */
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion: iBeaconが圏内に発見されました。");
        // Rangingを始める (Ranginghあ1秒ごとに呼ばれるので、検出中のiBeaconがなくなったら止める)
        manager.startRangingBeacons(in: region as! CLBeaconRegion)

    }
    
    /*
     [iBeacon イベント] iBeaconを喪失した際に呼ばれる. 喪失後 30秒ぐらいあとに呼び出される.
     */
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion: iBeaconが圏外に喪失されました。");
        
        // 検出中のiBeaconが存在しないのなら、iBeaconのモニタリングを終了する.
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    }
    
    /*
     Pageが全て読み終わったら呼ばれる.
     */
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewDidFinishLoad")
    }
    
    /*
     PageがLoadされ始めた時、呼ばれる.
     */
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDidStartLoad")
    }
    
}
