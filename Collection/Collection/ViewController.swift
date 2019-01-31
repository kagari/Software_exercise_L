//
//  ViewController.swift
//  Collection
//
//  Created by 大城昂希 on 2018/11/08.
//  Copyright © 2018 大城昂希. All rights reserved.
//

import UIKit
//var Twitter: Bool = false
//var Slack: Bool = false

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,UIApplicationDelegate {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    let image0:UIImage = UIImage(named:"Twitter_off")!
    let image1:UIImage = UIImage(named:"Twitter_on")!
    let image2:UIImage = UIImage(named:"Slack_off")!
    let image3:UIImage = UIImage(named:"Slack_on")!
//    var Twitter: Bool = false
//    var Slack: Bool = false

    
    var count1 = 0
    var count2 = 0

    @IBAction func button1(_ sender: Any) {
        count1 += 1
        if(count1%2 == 0){
            button1.setImage(image0, for: .normal)
            Twitter = false
        }
        else if(count1%2 == 1){
            button1.setImage(image1, for: .normal)
            Twitter = true
        }

    }
    
    @IBAction func button2(_ sender: Any) {
        count2 += 1
        if(count2%2 == 0){
            button2.setImage(image2, for: .normal)
            Slack = false
        }
        else if(count2%2 == 1){
            button2.setImage(image3, for: .normal)
            Slack = true
        }

    }
    let userDefaults = UserDefaults.standard
    var tableView: UITableView!
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    var textFieldHeight: CGFloat = 40
    
    var str: String!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // base64でencoding
        let originalString = "xxxxx"
        let originalData = originalString.data(using: .utf8)
        let encodedString = originalData?.base64EncodedString()
        print(encodedString!)

        let url = URL(string: "https://api.twitter.com/oauth2/token")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["Authorization": "Basic \(encodedString!)", "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"]
        urlRequest.httpBody = "grant_type=client_credentials".data(using: .utf8)

        // TwitterのAPI認証をするためにBearerTokenを取得する
        let task = URLSession.shared.dataTask(with: urlRequest) {
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
                    let token = dictionary["access_token"]
                    print("Bearer: \(token!)")
                    self.userDefaults.set(token!, forKey: "token")
                }
            } else {
                print("サーバエラー ステータスコード: \(response.statusCode)\n")
            }
        }
        task.resume()
        
        // labelがこのアプリの名前を表している
        label.text = "Collection"
        label.sizeToFit()
        // 画面上部中央に表示するための処理
        let screenWidth:CGFloat = view.frame.size.width
        label.center = CGPoint(x: screenWidth/2, y: 30)
        
        // searchBarはその名の通り検索窓
        searchBar.placeholder = "キーワード検索" // デフォルトで表示される文字列を指定
        searchBar.delegate = self
        
        //グラデーションをつける
        gradationColor()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        tableView.removeFromSuperview()
        addHistory(text: searchBar.text!)
        
        if (searchBar.text == ""){
            let alert = UIAlertController(title: "検索文字が入力されていません", message: "入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else if Slack == false && Twitter == false{
            let alert = UIAlertController(title: "検索結果がありませんでした", message: "検索したいアプリを選択してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            goToNextPage(message: searchBar.text!)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView = UITableView(frame: CGRect(x: 0, y: self.searchBar.frame.maxY, width: self.view.frame.width, height: CGFloat(getInputHistory().count) * self.textFieldHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        // データのないセルを表示しないようにする
        tableView.tableFooterView = UIView(frame: .zero)
        self.view.addSubview(tableView)
    }
    
    // MARK: - UITableView関連
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // テーブルセルの数を設定（必須）
        return getInputHistory().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // テーブルセルを作成（必須）
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = getInputHistory()[indexPath.row]
        // セルタップ時の挙動がセットされている
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.inputFromHistory(sender:))))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // テーブルセルの高さを設定
        return textFieldHeight
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        // 左スワイプして出てくる削除ボタンのテキスト
        return "削除"
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 左スワイプして出てくる削除ボタンを押した時の処理
        let swipeCellA = UITableViewRowAction(style: .default, title: "削除") { action, index in
            self.removeHistory(index: indexPath.row) // 押されたときの動きを定義しています
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
        return [swipeCellA]
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // すべてのセルを削除可能に
        return true
    }
    
    // 新しく履歴に追加
    func addHistory(text: String) {
        if text == "" {
            return
        }
        var histories = getInputHistory()
        for word in histories {
            if word == text {
                // すでに履歴にある場合は追加しない
                return
            }
        }
        histories.insert(text, at: 0)
        userDefaults.set(histories, forKey: "inputHistory")
    }
    
    // 履歴を一つ削除
    func removeHistory(index: Int) {
        var histories = getInputHistory()
        histories.remove(at: index)
        userDefaults.set(histories, forKey: "inputHistory")
    }
    
    // 履歴取得
    func getInputHistory() -> [String] {
        if let histories = userDefaults.array(forKey: "inputHistory") as? [String] {
            return histories
        }
        return []
    }
    
    // UITableViewCellから履歴を入力
    @objc func inputFromHistory(sender: UITapGestureRecognizer) {
        if let cell = sender.view as? UITableViewCell {
            searchBar.text = cell.textLabel?.text
        }
    }
    
    // 次のページに移る際にqueryを次のページに送る
    func goToNextPage(message: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.message = message
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "nextViewController")
        present(nextViewController!, animated: false, completion: nil)
    }
    
    // グラデーションをつける関数
    func gradationColor() {
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
