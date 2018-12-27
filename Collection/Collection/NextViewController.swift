//
//  NextViewController.swift
//  Collection
//
//  Created by 大城昂希 on 2018/11/08.
//  Copyright © 2018 大城昂希. All rights reserved.
//

import UIKit
import SafariServices

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
    
    let userDefaults = UserDefaults.standard
    
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
                        // 正常にSlackAPIを使って情報を取れたか判断
                        if dictionary["ok"] as! Bool {
                            let apiMessage = dictionary["messages"] as! [String: Any]
                            let matches = apiMessage["matches"] as! [Any]
                            // 返ってきた結果(検索結果)が空かどうか判定
                            // 空だった場合アラートを出す
                            if matches.isEmpty {
                                let alert = UIAlertController(title: "検索結果がありませんでした", message: "別の検索ワードで試してみてください", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true)
                            }
                            for matche in matches {
                                let texts = matche as! [String: Any]
                                // mainthreaddで実行(これを書かないと怒られる)
                                DispatchQueue.main.async() { () -> Void in
                                    var responseData = [String: Any]()
                                    responseData["username"] = texts["username"]! as? String
                                    responseData["text"] = texts["text"]! as? String
                                    responseData["permalink"] = texts["permalink"]! as? String
                                    self.resultDatas.append(responseData)
                                }
                            }
                        }else{
                            // SlackAPIがうまく使えていない場合、アラートを出す
                            let alert = UIAlertController(title: "Slackとの連携が行われていません", message: "連携を確認してもう一度お試しください", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
            } else {
                print("サーバエラー ステータスコード: \(response.statusCode)\n")
            }
        }
        task.resume()
        
        // TwitterのAPIを使用して検索を行う
        let twitterURL = URL(string: "https://api.twitter.com/1.1/tweets/search/fullarchive/prod.json")
        var twitterURLRequest = URLRequest(url: twitterURL!)
        twitterURLRequest.httpMethod = "POST"
        twitterURLRequest.httpBody = "{\"query\" : \"\(query)\"}".data(using: .utf8)
        if let token = userDefaults.string(forKey: "token"){
            twitterURLRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(token)", "lang": "ja"]
        }
        let twitterTask = URLSession.shared.dataTask(with: twitterURLRequest) {
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
                let json = try? JSONSerialization.jsonObject(with: data)
                if let dictionary = json as? [String: Any]{
                    let results = dictionary["results"] as! [[String:Any]]
//                    let texts = results["text"] as! String
                    for result in results {
//                        print("Results: \(result)")
                        DispatchQueue.main.async() { () -> Void in
                            let userConf = results[0]["user"] as! [String:Any]
//                            print("@\(userConf["screen_name"]!)")
                            var responseData = [String: Any]()
                            responseData["username"] = "@\(userConf["screen_name"]!)"
                            responseData["text"] = result["text"] as! String
//                            responseData["permalink"] = result["permalink"] as! URL
                            self.resultDatas.append(responseData)
                        }
                    }
                }
            }else{
                print("サーバエラー ステータスコード: \(response.statusCode)\n")
            }
        }
        twitterTask.resume()
        gradation_color()
        
        // データのないセルを表示しないようにする
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
    
    // セルタップ時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pass = indexPath[1]
        let url = URL(string: self.resultDatas[pass]["permalink"] as! String)
        let browser = SFSafariViewController(url: url!)
        present(browser, animated: true, completion: nil)
        
    }
    
    // トークン取得のための関数
    func getToken() -> String {
        let token: String = "xxxxxx"
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
