//
//  NextViewController.swift
//  Collection
//
//  Created by 大城昂希 on 2018/11/08.
//  Copyright © 2018 大城昂希. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textLabel: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func backButtom(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // URLから情報を取得する
//        let testURL = URL(string: "https://www.pakutaso.com/shared/img/thumb/neko1869IMG_9052_TP_V.jpg")!
//        _ = URLSession.shared.dataTask(with: testURL) { (data, response, error) in
//            if error == nil{
//                let loadedImage = UIImage(data: data!)
//                self.iconLabel.image = loadedImage
//            }
//        }
        
        // slackAPIを叩く
        let url = URL(string: "https://slack.com/api/api.test")!
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            if let error = error {
                print("クライアントエラー: \(error.localizedDescription) \n")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("no data or no response")
                return
            }
            
            if response.statusCode == 200 {
                print("-------------------------")
                let str: String? = String(data: data, encoding: .utf8)
                print(str)
                print("-------------------------")
            } else {
                print("サーバエラー ステータスコード: \(response.statusCode)\n")
            }
        }
        task.resume()
        //グラデーションをつける
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        //グラデーションさせるカラーの設定
        //今回は、徐々に色を濃くしていく
        let color1 = UIColor(red: 120/256.0, green: 200/256.0, blue: 126/256.0, alpha: 0.5).cgColor
        let color2 = UIColor(red: 120/256.0, green: 150/256.0, blue: 256/256.0, alpha: 0.5).cgColor
        
        //CAGradientLayerにグラデーションさせるカラーをセット
        gradientLayer.colors = [color1, color2]
        
        //グラデーションの開始地点・終了地点の設定
        //上が白で下が水色
        gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5 , y:1 )
        self.view.layer.insertSublayer(gradientLayer,at:0)
    }
    

    /*
    // MARK: - Navigation A

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
