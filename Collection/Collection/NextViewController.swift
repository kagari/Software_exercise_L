//
//  NextViewController.swift
//  Collection
//
//  Created by 大城昂希 on 2018/11/08.
//  Copyright © 2018 大城昂希. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    var pretext: String!
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        print(appDelegate.message!)
        // Do any additional setup after loading the view.
        
        // tokenを取得する
        let token = getToken()
        // 検索ワード
        let query = appDelegate.message!
        // slackAPIを叩く
        let url = URL(string: "https://slack.com/api/search.all?token=\(token)&query=\(query)")!
        print("----------------------\n" + url.absoluteString + "\n-----------------------")
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
//                print("-------------------------")
//                print(str!)
//                print("-------------------------")
                guard let result = str?.data(using: .utf8) else {return}
                do {
                    let json = try? JSONSerialization.jsonObject(with: result)
//                    print(json as Any)
                    if let dictionary = json as? [String: Any]{
                        let apiMessage = dictionary["messages"] as! [String: Any]
//                        print(apiMessage)
                        let matches = apiMessage["matches"] as! [Any]
                        for matche in matches {
                            let texts = matche as! [String: Any]
                            print("----------------------------")
                            print(texts["text"]! as Any)
                            // mainthreaddで実行(これを書かないと怒られる)
                            DispatchQueue.main.async() { () -> Void in
                                self.textLabel.text = texts["text"]! as Any as? String
                            }
                        }
//                        for matches in apiMessage["matches"] as! [String: Any] {
//                            print(matches)
//                        }
                    }
                }
            } else {
                print("サーバエラー ステータスコード: \(response.statusCode)\n")
            }
        }
        task.resume()
    }
    
    func getToken() -> String {
        let token: String = "xxxxxxxx"
        return token
    }
    
    func setText(_ responseData: String){
        pretext = responseData
        print(pretext)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
