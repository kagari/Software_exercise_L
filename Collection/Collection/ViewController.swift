//
//  ViewController.swift
//  Collection
//
//  Created by 大城昂希 on 2018/11/08.
//  Copyright © 2018 大城昂希. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

//    let query: String
//    let responseData: String
//    let searchApiUrl: String
//    let searchMode: intmax_t
    
    let userDefaults = UserDefaults.standard
    var tableView: UITableView!
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    var textFieldHeight: CGFloat = 40
    
    var str: String!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        }else{
            goToNextPage(message: searchBar.text!)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let topMargin = statusBarHeight + textFieldHeight
        
        tableView = UITableView(frame: CGRect(x: 0, y: topMargin, width: self.view.frame.width, height: self.view.frame.height - topMargin))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        tableView.allowsSelection = false
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
    
    private func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 左スワイプして出てくる削除ボタンを押した時の処理
        
        removeHistory(index: indexPath.row)
        
        tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
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




