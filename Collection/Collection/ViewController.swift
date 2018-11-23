//
//  ViewController.swift
//  Collection
//
//  Created by 大城昂希 on 2018/11/08.
//  Copyright © 2018 大城昂希. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func button(_ sender: Any) {
        if (searchBar.text == ""){
            let alert = UIAlertController(title: "検索文字が入力されていません", message: "入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello, World")
    
        
        //グラデーションをつける
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        //グラデーションさせるカラーの設定
        //今回は、徐々に色を濃くしていく
        let color1 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1).cgColor     //白
        let color2 = UIColor(red: 120/256.0, green: 150/256.0, blue: 256/256.0, alpha: 1).cgColor   //水色
        
        //CAGradientLayerにグラデーションさせるカラーをセット
        gradientLayer.colors = [color1, color2]
        
        //グラデーションの開始地点・終了地点の設定
        //上が白で下が水色
        gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5 , y:1 )
        
        //左が白で右が水色
        //gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        //gradientLayer.endPoint = CGPoint.init(x: 1 , y:0.5)
        
        //左上が白で右下が水色
        //gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        //gradientLayer.endPoint = CGPoint.init(x: 1 , y:1)
        
        //ViewControllerのViewレイヤーにグラデーションレイヤーを挿入する
        self.view.layer.insertSublayer(gradientLayer,at:0)
    }
}
