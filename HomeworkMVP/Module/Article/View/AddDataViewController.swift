//
//  AddDataViewController.swift
//  HomeworkMVP
//
//  Created by Song Seaktheng on 12/16/16.
//  Copyright © 2016 Song Seaktheng. All rights reserved.
//

import UIKit

class AddDataViewController: UIViewController, PresenterInteface{
    func responseData(data: [ListData], pagination: Pagination, type:String) {
        
    }

    var article:ListData!
    
    
    var tableController : PresenterInteface!
    
    
    @IBOutlet weak var titleAdd: UITextField!
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var descriptionAdd: UITextField!
    
//    var session : URLSession!
//    var uploadTask : URLSessionUploadTask!
    
    var indexToUpdate:Int = 0
    let articlePresenter = Presenter()
    var arrayData:[ListData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlePresenter.delegate = self
        if article != nil {
            titleAdd.text = article.title
            descriptionAdd.text = article.description
            let imageURL = URL(string:article.image!)
            
            imageAdd.kf.setImage(with: imageURL, placeholder: UIImage(named: "img22"), options: nil, progressBlock: nil, completionHandler: nil)
            
        }
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(browseImage(_:)))
        imageAdd.isUserInteractionEnabled = true
        imageAdd.addGestureRecognizer(tapGesture)
    }
    

    
    @IBAction func donePressed(_ sender: Any) {
        
        let data = UIImagePNGRepresentation(imageAdd.image!)
        
        let url = URL(string: "http://120.136.24.174:1301/v1/api/uploadfile/single")
        var request = URLRequest(url: url!)
        
        // Set method
        request.httpMethod = "POST"
        
        request.setValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        
        // Set boundary
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Create requestBody
        var formData = Data()
        
        
        let mimeType = "image/png" // Multipurpose Internet Mail Extension
        formData.append("--\(boundary)\r\n".data(using: .utf8)!)
        formData.append("Content-Disposition: form-data; name=\"FILE\"; filename=\"Image.png\"\r\n".data(using: .utf8)!)
        formData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        formData.append(data!)
        formData.append("\r\n".data(using: .utf8)!)
        formData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = formData
        
        print(formData)
        
        
        let uploadTask = URLSession.shared.dataTask(with: request){
            
            data, response, error in
            
            var imageResponse: String?
            if error == nil{
                
                print("Success : \(response)")
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    
                    imageResponse = json["DATA"] as? String
                    
                    print("-------------------------Image Success")
                    print(imageResponse)
                    
                    self.postData(imageURL: imageResponse!)
                    
                }catch let error{
                    print("Error : \(error.localizedDescription)")
                }
                
                
            }else{
                
                print("\(error?.localizedDescription)")
            }
        }
        uploadTask.resume()

    }
    
    func postData(imageURL:String){
        
        if article == nil {
            
            article = ListData(title: titleAdd.text!, description: descriptionAdd.text!, image: imageURL)
            articlePresenter.addArticle(article: article!, imageURL: imageURL)
            DispatchQueue.main.sync {
                
                _=navigationController?.popViewController(animated: true)
                
                
            }
            
        }else{
            
            article.title = titleAdd.text!
            article.description = descriptionAdd.text!
            article.image = imageURL
            articlePresenter.editArticle(article: article!, imageURL: imageURL)
            let tableController = self.tableController as! DataTableViewController
            tableController.updateList(article, indexToUpdate)
            DispatchQueue.main.sync {
                _=navigationController?.popViewController(animated: true)
            }

        }
        
        _=navigationController?.popViewController(animated: true)
    }
    
    func sucess(data: ListData) {
        print("add suceess \(data.description)")
        print("add suceess \(data.title)")
        
        
//          let tableController = self.tableController as! DataTableViewController
//        tableController.sucess(data: data)
    }
    
    
    func errorPresenter(){}
    func responseData(_ data: [ListData]){}
    func response(data:HTTPURLResponse){}
    func successDelete(data:AnyObject){}
    func successUpload(data:[String:AnyObject]){}
    func success(data:[String:AnyObject]){}
    func errorUpload(data:NSError){}
    func error(data:NSError){}
    func editSuccess(data:[String:AnyObject]){}

       
}
extension AddDataViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Browse Image
    func browseImage(_ tapGesture: UITapGestureRecognizer){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Upload when finish
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //Get as UIImage
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.imageAdd.image = image
        }
    
        picker.dismiss(animated: true, completion: nil)
    }
    
}
