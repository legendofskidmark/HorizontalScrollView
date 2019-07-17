//
//  ViewController.swift
//  test
//
//  Created by Boon on 09/07/19.
//  Copyright © 2019 Boon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Variables
    var display_data: [Dictionary< String,(String, String) >] = []
    
    let session = URLSession.shared
    
    let url = URL(string: "https://www.quikr.com/core/quikrcom/pwa_ccm/get-quikr-assured-carousel?cityId=33")!

    //MARK:- IBOutlets
    @IBOutlet weak var quikrCollectionView: UICollectionView!
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        }

    //MARK:- Private methods
    private func abc() {
        
    }
    
    func abcd() {
        
    }
    //MARK:- IBActions
    @IBAction func ButtonPressed(_ sender: Any) {
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            // multi-purpose internet mail extensions --> mime
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                let dict = json as! Dictionary<String,Any>
                let doi = dict["categoryLinks"]
                let intermediateData = doi as! Array<Any>
                
                
                for data in intermediateData{
                    let p = data as! Dictionary<String,Any>
                    print("55", p["image"] as! String)
                    self.display_data.append(["cellContent" : (p["name"] as! String, p["image"] as! String)])
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        
        
    }
    
}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return display_data.count > 0 ? display_data.count : 11
  
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //
    
    let cell = quikrCollectionView.dequeueReusableCell(withReuseIdentifier: "HSCell", for: indexPath) as! QuikrCollectionViewCell
    
    
    
//   print("87", display_data)
    
    if display_data.count > 0 {
        print("found", display_data[indexPath.row]["cellContent"]!)
        cell.cellLabel.text = display_data[indexPath.row]["cellContent"]?.0
        cell.quikrImage.load(url: URL(string: display_data[indexPath.row]["cellContent"]!.1)!)
    }else{
        cell.cellLabel.text = String(indexPath.row)
        }
    
    return cell
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
