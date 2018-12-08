//
//  NextViewController.swift
//  Collection
//
//  Created by 大城昂希 on 2018/11/08.
//  Copyright © 2018 大城昂希. All rights reserved.
//

import UIKit

class NextViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 検索結果を格納するための空の配列を用意
    // 値を格納するたびにテーブルをリロードする
    var resultDatas = [Dictionary<String, Any>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backButtom(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 検索クエリを橋渡しするためのappDelegateのインスタンスを作成
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // tokenを取得する
        let token = getToken()
        // 検索ワード
        let query = appDelegate.message!
        
        // 検索を行う
        var url_text: String! = "https://slack.com/api/search.all?token=\(token)&query=\(query)"
        url_text = url_text.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: url_text)!
        // slackAPIを叩く
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
                let str = String(data: data, encoding: .utf8)

                guard let result = str?.data(using: .utf8) else {return}
                do {
                    let json = try? JSONSerialization.jsonObject(with: result)
                    if let dictionary = json as? [String: Any]{
                        let apiMessage = dictionary["messages"] as! [String: Any]
                        let matches = apiMessage["matches"] as! [Any]
                        for matche in matches {
                            let texts = matche as! [String: Any]
                            // mainthreaddで実行(これを書かないと怒られる)
                            DispatchQueue.main.async() { () -> Void in
                                var responseData = [String: Any]()
                                responseData["username"] = texts["username"]! as? String
                                responseData["text"] = texts["text"]! as? String
                                responseData["permalink"] = texts["permalink"]! as? URL
                                self.resultDatas.append(responseData)
                            }
                        }
                    }
                }
            } else {
                print("サーバエラー ステータスコード: \(response.statusCode)\n")
            }
        }
        task.resume()
        gradation_color()
        
        // セルをテーブルに紐付ける
        // なぜかTextCellの値にnilが動かなくなるのでコメントアウト
//        tableView.register(TextCell.self, forCellReuseIdentifier: "cell")
        // データのないセルを表示しないようにするハック
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultDatas.count
    }
    
    // セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TextCell
        // セルに表示する値を設定する
        cell.userNameLabel.text = resultDatas[indexPath.row]["username"] as? String
        cell.responseLabel.text = resultDatas[indexPath.row]["text"] as? String
        return cell
    }
    
    // セルの高さ指定をする処理
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // UITableViewCellの高さを自動で取得する値
        return UITableView.automaticDimension
    }
    
    // トークン取得のための関数
    func getToken() -> String {
        let token: String = "xxxxxxxxxxxxxxx"
        return token
    }
    
    // グラデーションを付けるメソッドを用意
    func gradation_color() {
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
    
}
