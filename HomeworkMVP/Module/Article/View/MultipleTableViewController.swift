//
//  MultipleTableViewController.swift
//  HomeworkMVP
//
//  Created by Theng on 12/18/16.
//  Copyright © 2016 Song Seaktheng. All rights reserved.
//

import UIKit
import DKImagePickerController
import Alamofire

class MultipleTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    
   
   
    @IBOutlet weak var myTableView: UITableView!
    
    let pickerController = DKImagePickerController()
    var imageAsset:[DKAsset]!
    var tempAsset:[DKAsset]!
    
    var imagePath:[URL] = [URL]()
    
    var fileUIImage: [UIImage] = [UIImage]()
    
    let headers: HTTPHeaders = [
        "Authorization": "Basic cmVzdGF1cmFudEFETUlOOnJlc3RhdXJhbnRQQFNTV09SRA==",
        "Accept": "application/json"
    ]

    @IBAction func backButton(_ sender: AnyObject) {
        
        navigationController!.popViewController(animated: true)
    }
    @IBAction func browserButton(_ sender: UIBarButtonItem) {
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            print("=========didSelectAssets============")
            print(assets)
            
            for asset in assets {
                
                asset.fetchOriginalImageWithCompleteBlock({ (image, info) in
                    
                    self.fileUIImage.append(image!)
                    self.myTableView.reloadData()
                    
                    self.imagePath.append(info!["PHImageFileURLKey"] as! URL)
                    
                })
            }
        }
        
        present(pickerController, animated: true, completion: {
            
            self.pickerController.deselectAllAssets()
        })

    }
    @IBAction func uploadButton(_ sender: UIBarButtonItem) {
        

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                
                for fileImage in self.fileUIImage {
                    
                    multipartFormData.append(UIImageJPEGRepresentation(fileImage, 0.6)!, withName: "files", fileName:"image.jpg", mimeType: "image/jpg")
                }
                
                multipartFormData.append("restaurant".data(using: .utf8)!, withName: "name")
                
            },
            
            to: "http://120.136.24.174:15020/v1/api/admin/upload/multiple",
            method: HTTPMethod(rawValue: "POST")!,
            headers: headers,
            
            
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fileUIImage.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "multipleCell", for: indexPath) as! AddMultipleImageTableViewCell
        
        cell.myImageView.image = fileUIImage[indexPath.row]
        
        return cell

    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            imagePath.remove(at: indexPath.row)
            fileUIImage.remove(at: indexPath.row)
            
        }
        
        myTableView.reloadData()
    }

}
