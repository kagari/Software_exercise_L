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
        
        // labelがこのアプリの名前を表している
        label.text = "Collection"
        label.sizeToFit()
        // 画面上部中央に表示するための処理
        let screenWidth:CGFloat = view.frame.size.width
        label.center = CGPoint(x: screenWidth/2, y: 30)
        
        // searchBarはその名の通り検索窓
        searchBar.placeholder = "キーワード検索" // デフォルトで表示される文字列を指定
        // enterキーを押した時に画面遷移させるために書いた
        // TODO: enter keyを押した時にどうにか画面遷移させる
//        if searchBar.isSearchResultsButtonSelected {
//            let storyboard: UIStoryboard = UIStoryboard(name: "Next", bundle: nil)
//            let NextViewController = storyboard.instantiateViewController(withIdentifier: "Next")
//            self.present(NextViewController, animated: true, completion: nil)
//        }
        
        //グラデーションをつける
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        //グラデーションさせるカラーの設定
        //今回は、徐々に色を濃くしていく
        let color1 = UIColor(red: 120/256.0, green: 170/256.0, blue: 126/256.0, alpha: 0.5).cgColor     //白
        let color2 = UIColor(red: 120/256.0, green: 150/256.0, blue: 256/256.0, alpha: 0.5).cgColor   //水色
        
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
       // gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        //gradientLayer.endPoint = CGPoint.init(x: 1 , y:1)
        
        //ViewControllerのViewレイヤーにグラデーションレイヤーを挿入する
        self.view.layer.insertSublayer(gradientLayer,at:0)
    }
}
