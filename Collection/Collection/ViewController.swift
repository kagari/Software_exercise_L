//
//  ViewController.swift
//  Collection
//
//  Created by 大城昂希 on 2018/11/08.
//  Copyright © 2018 大城昂希. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    

    @IBOutlet weak var button: UIButton!
    var Twitter: Bool = false
    var Slack: Bool = false
    var count1 = 0
    @IBAction func button2(_ sender: Any) {
        count1 += 1
        if(count1%2 == 0){
            button.setImage(image0, for: .normal)
            self.Twitter = false
        }
        else if(count1%2 == 1){
            button.setImage(image1, for: .normal)
            self.Twitter = true
        }
    }
    // UIImage のインスタンスを設定
    
    @IBOutlet weak var button2: UIButton!
    var count2 = 0
    @IBAction func button3(_ sender: Any) {
        count2 += 1
        if(count2%2 == 0){
            button2.setImage(image2, for: .normal)
            self.Slack = false
        }
        else if(count2%2 == 1){
            button2.setImage(image3, for: .normal)
            self.Slack = true
        }
    }
    
    let image0:UIImage = UIImage(named:"Twitter_off")!
    let image1:UIImage = UIImage(named:"Twitter_on")!
    
    let image2:UIImage = UIImage(named:"Slack_off")!
    let image3:UIImage = UIImage(named:"Slack_on")!

    var tableView: UITableView!
   @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
   @IBAction func button(_ sender: Any) {
        if (searchBar.text == ""){
            let alert = UIAlertController(title: "検索文字が入力されていません", message: "入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
       
    }
    
 /* override func viewDidLoad() {
        super.viewDidLoad()
        setView()}


   // 回転を検知
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.rotationChange(notification:)),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
        setView()
    }
    
<<<<<<< HEAD

=======
    @objc
    func rotationChange(notification: NSNotification){
       // width = Int(view.frame.width)
      //  height = Int(view.frame.height)
    
        setView()
       
    }
    func setView() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        //グラデーションさせるカラーの設定
        //今回は、徐々に色を濃くしていく
        let color1 = UIColor(red: 120/256.0, green: 170/256.0, blue: 126/256.0, alpha: 0.5).cgColor     //白
        let color2 = UIColor(red: 120/256.0, green: 150/256.0, blue: 256/256.0, alpha: 0.5).cgColor   //水色
        //gradientLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //CAGradientLayerにグラデーションさせるカラーをセット
        gradientLayer.colors = [color1, color2]
        
        //グラデーションの開始地点・終了地点の設定
        //上が白で下が水色
        gradientLayer.startPoint = CGPoint.init(x: 0, y:0.5 )
        gradientLayer.endPoint = CGPoint.init(x: 1, y:0.5 )
        //gradientLayer.frame = self.view.bounds
        //左が白で右が水色
        //gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        //gradientLayer.endPoint = CGPoint.init(x: 1 , y:0.5)
        
        //左上が白で右下が水色
       // gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        //gradientLayer.endPoint = CGPoint.init(x: 1 , y:1)
        
        //ViewControllerのViewレイヤーにグラデーションレイヤーを挿入する
        self.view.layer.insertSublayer(gradientLayer,at:0)
        
}
    
    
}
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    
   
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        //グラデーションさせるカラーの設定
        //今回は、徐々に色を濃くしていく
        let color1 = UIColor(red: 120/256.0, green: 170/256.0, blue: 126/256.0, alpha: 0.5).cgColor     //白
        let color2 = UIColor(red: 120/256.0, green: 150/256.0, blue: 256/256.0, alpha: 0.5).cgColor   //水色
        //gradientLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //CAGradientLayerにグラデーションさせるカラーをセット
        gradientLayer.colors = [color1, color2]
        
        //グラデーションの開始地点・終了地点の設定
        //上が白で下が水色
        gradientLayer.startPoint = CGPoint.init(x: 0, y:0.5 )
        gradientLayer.endPoint = CGPoint.init(x: 1, y:0.5 )
        //gradientLayer.frame = self.view.bounds
        //左が白で右が水色
        //gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        //gradientLayer.endPoint = CGPoint.init(x: 1 , y:0.5)
        
        //左上が白で右下が水色
        // gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        //gradientLayer.endPoint = CGPoint.init(x: 1 , y:1)
        
        //ViewControllerのViewレイヤーにグラデーションレイヤーを挿入する
        self.view.layer.insertSublayer(gradientLayer,at:0)
    
    
    }
    override func viewDidAppear(_ animated: Bool) {
       
        // 端末の向きがかわったらNotificationを呼ばす設定.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.onOrientationChange(notification:)), name:
            UIDevice.orientationDidChangeNotification, object: nil)
    } // 端末の向きがかわったら呼び出される.
    @objc func onOrientationChange(notification: NSNotification){
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation //error here
        // 現在のデバイスの向きを取得.
        let _: UIDeviceOrientation!  = UIDevice.current.orientation
       
        // 向きの判定.
        if orientation.isLandscape {
            
            //横向きの判定.
            //向きに従って位置を調整する.
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            
            //グラデーションさせるカラーの設定
            //今回は、徐々に色を濃くしていく
            let color1 = UIColor(red: 120/256.0, green: 170/256.0, blue: 126/256.0, alpha: 0.5).cgColor     //白
            let color2 = UIColor(red: 120/256.0, green: 150/256.0, blue: 256/256.0, alpha: 0.5).cgColor   //水色
            //gradientLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            //CAGradientLayerにグラデーションさせるカラーをセット
            gradientLayer.colors = [color1, color2]
            
            //グラデーションの開始地点・終了地点の設定
            //上が白で下が水色
            gradientLayer.startPoint = CGPoint.init(x: 0, y:0.5 )
            gradientLayer.endPoint = CGPoint.init(x: 1, y:0.5 )
            //gradientLayer.frame = self.view.bounds
            //左が白で右が水色
            //gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
            //gradientLayer.endPoint = CGPoint.init(x: 1 , y:0.5)
            
            //左上が白で右下が水色
            // gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
            //gradientLayer.endPoint = CGPoint.init(x: 1 , y:1)
            
            //ViewControllerのViewレイヤーにグラデーションレイヤーを挿入する
            self.view.layer.insertSublayer(gradientLayer,at:0)
            
            
        } else if orientation.isPortrait{
            
            //縦向きの判定.
            //向きに従って位置を調整する.
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            
            //グラデーションさせるカラーの設定
            //今回は、徐々に色を濃くしていく
            let color1 = UIColor(red: 120/256.0, green: 170/256.0, blue: 126/256.0, alpha: 0.5).cgColor     //白
            let color2 = UIColor(red: 120/256.0, green: 150/256.0, blue: 256/256.0, alpha: 0.5).cgColor   //水色
            //gradientLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            //CAGradientLayerにグラデーションさせるカラーをセット
            gradientLayer.colors = [color1, color2]
            
            //グラデーションの開始地点・終了地点の設定
            //上が白で下が水色
            gradientLayer.startPoint = CGPoint.init(x: 0.5, y:0 )
            gradientLayer.endPoint = CGPoint.init(x: 0.5, y:1 )
            //gradientLayer.frame = self.view.bounds
            //左が白で右が水色
            //gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
            //gradientLayer.endPoint = CGPoint.init(x: 1 , y:0.5)
            
            //左上が白で右下が水色
            // gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
            //gradientLayer.endPoint = CGPoint.init(x: 1 , y:1)
            
            //ViewControllerのViewレイヤーにグラデーションレイヤーを挿入する
            self.view.layer.insertSublayer(gradientLayer,at:0)
            
            
        }
    }
    
// タップすると画像を順番に変える
/*func buttonTapped(sender : AnyObject) {
    count += 1
    if(count%2 == 0){
        button.setImage(image0, for: .normal)
    }
    else if(count%2 == 1){
        button.setImage(image1, for: .normal)
    }
    
}*/
}
