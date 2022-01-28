//
//  CreateUserViewController.swift
//  HARI_DISYS
//
//  Created by Hariharasudhan J on 27/01/22.
//

import UIKit

class CreateUserViewController: UIViewController {
    @IBOutlet weak var buttonMale: UIButton!
    @IBOutlet weak var buttonFemale: UIButton!
    var userDetails = [String:Any]()
    var isEditMode : Bool = false
    @IBOutlet weak var textFieltEmail: UITextField!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var textFieldName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Fill details in edit mode
        if(isEditMode){
            self.title = "Edit User"
            buttonDelete.isEnabled = true

            textFieldName.text = userDetails["name"] as! String
            textFieltEmail.text = userDetails["email"] as! String
            let gender = userDetails["gender"] as! String
            if(gender == "male"){
                buttonMale.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                buttonFemale.setImage(UIImage(systemName: "stop"), for: .normal)

            }else{
                buttonFemale.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                buttonMale.setImage(UIImage(systemName: "stop"), for: .normal)

            }
        }else{
            self.title = "Create User"
            buttonDelete.isEnabled = false
            buttonMale.isSelected = true
            userDetails["gender"] = "Male"
        }
    }
    //MARK: Button Actions
    
    @IBAction func deleteTapped(_ sender: Any) {
        let url = "https://gorest.co.in/public/v1/users/\(userDetails["id"]!)"
        var request = URLRequest(url: URL(string: url)!)
      //set httpHeaders
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer aa6ed05a183cc25bc16d46165a2e230863743e59972c44d4844b524149bb36fc", forHTTPHeaderField: "Authorization")

        request.httpMethod = "DELETE"
        let session = URLSession.shared

        let task = session.dataTask(with: URL(string: url)!) { (data, response, error) in
            if((error == nil)){
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "", message: "Deleted Successfully", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                                self.present(alert, animated: true, completion: nil)
                }
            }
        }
        task.resume()

            }
    

    @IBAction func submitTapped(_ sender: Any) {
        if(self.isValidEmail(textFieltEmail.text!)) && (self.isValidName(name: textFieldName.text!)){
            userDetails["name"] = textFieldName.text
            userDetails["email"] = textFieltEmail.text
            userDetails["status"] = "active"
            let url = URL(string: APIManager.shared.hostURL() + APIManager.URLPaths.createUser)!
            var urlString =  APIManager.shared.hostURL() + APIManager.URLPaths.createUser
            if(isEditMode){
                update()
                urlString = urlString + "/\(userDetails["id"] ?? "123")"

            }else{
                ApiCalls.createuser(urlString: urlString, parameter: userDetails as! Dictionary<String,String>){[self](data) in
                    do {
                        if let value = String(data: data as Data, encoding: String.Encoding.ascii) {

                            if let jsonData = value.data(using: String.Encoding.utf8) {
                    do {
                                    let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]

                                    if let data = json["data"] as? [String: Any] {
                                        if let idvalue = data["id"]{
                                            print("UserCreated")
                                            DispatchQueue.main.async {
                                                let alert = UIAlertController(title: "", message: "Created Successfully", preferredStyle: UIAlertController.Style.alert)
                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                                                    self.navigationController?.popToRootViewController(animated: true)
                                                }))
                                                            self.present(alert, animated: true, completion: nil)
                                            }
                                            
                                        }
                                        
                                    }

                                } catch {
                                    NSLog("ERROR \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                    catch let error as NSError {
                        print("API error: \(error.debugDescription)")
                    }
                    
                }
            }
            
        }else{
            let alert = UIAlertController(title: "Error", message: "Please enter all fields / Invalid email", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func buttonMaleTapped(_ sender: UIButton) {
        userDetails["gender"] = buttonMale.titleLabel?.text
        sender.isSelected = !sender.isSelected
        buttonFemale.isSelected = false
        buttonFemale.setImage(UIImage(systemName: "Stop"), for: .normal)

    }
    func update(){
        let url = "https://gorest.co.in/public/v1/users/\(userDetails["id"]!)"
        var request = URLRequest(url: URL(string: url)!)
      //set httpHeaders
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer aa6ed05a183cc25bc16d46165a2e230863743e59972c44d4844b524149bb36fc", forHTTPHeaderField: "Authorization")
        
        //set parameters
        request.httpMethod = "PUT"
        userDetails["name"] = textFieldName.text
        userDetails["email"] = textFieltEmail.text
        userDetails.removeValue(forKey: "id")
        let dictionary = userDetails as! Dictionary<String,String>
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dictionary) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        }
        request.httpBody = try! JSONEncoder().encode(dictionary)

        URLSession.shared.dataTask(with:URL(string: url)!) { (data, res, err) in

                if let d = data {
                    if let value = String(data: d, encoding: String.Encoding.ascii) {

                        if let jsonData = value.data(using: String.Encoding.utf8) {
                            do {
                                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                                
                                if let arr = json["data"] as? [String: Any] {
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: "Success", message: "Updated successfully!", preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                                            self.navigationController?.popToRootViewController(animated: true)
                                        }))
                                                    self.present(alert, animated: true, completion: nil)
                                    }
                                    
                                }

                            } catch {
                                NSLog("ERROR \(error.localizedDescription)")
                            }
                        }
                    }

                }
                }.resume()
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidName(name:String) -> Bool{
        if name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            return false
        }else{
            return true
        }
    }

    
    @IBAction func buttonFemaleTapped(_ sender: UIButton) {
        userDetails["gender"] = buttonFemale.titleLabel?.text
        sender.isSelected = !sender.isSelected
        buttonMale.isSelected = false
         buttonMale.setImage(UIImage(systemName: "Stop"), for: .normal)

        

    }
}

