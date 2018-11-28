//
//  ViewController.swift
//  Collection
//
//  Created by 大城昂希 on 2018/11/08.
//  Copyright © 2018 大城昂希. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    let query: String
//    let responseData: String
//    let searchApiUrl: String
//    let searchMode: intmax_t
    var str: String!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func button(_ sender: Any) {
        if (searchBar.text == ""){
            let alert = UIAlertController(title: "検索文字が入力されていません", message: "入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            goToNextPage(message: searchBar.text!)
        }
    }
    
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
        
        // enterキーを押した時に画面遷移させるために書いた
        // TODO: enter keyを押した時にどうにか画面遷移させる
//        if searchBar.isSearchResultsButtonSelected {
//            let storyboard: UIStoryboard = UIStoryboard(name: "Next", bundle: nil)
//            let NextViewController = storyboard.instantiateViewController(withIdentifier: "Next")
//            self.present(NextViewController, animated: true, completion: nil)
//        }
    }
    
    // 次のページに移る際にjsonを次のページに送る
    func goToNextPage(message: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.message = message
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "nextViewController")
        present(nextViewController!, animated: false, completion: nil)
    }
}
