//
//  UsersListViewController.swift
//  HARI_DISYS
//
//  Created by Hariharasudhan J on 28/01/22.
//

import UIKit

class UsersListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var usersTableView: UITableView!
    var userList = [[String: Any]]()
    var nextUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        let urlString =  APIManager.shared.hostURL() + APIManager.URLPaths.createUser
        GetUsers(urlString: urlString)
    }
    
    //MARK: Api calls
    func GetUsers(urlString:String){

        ApiCalls.getDataFrom(urlString:urlString) { [self] (data) in
            do {
                if let value = String(data: data as Data, encoding: String.Encoding.ascii) {
           //convert json to dictionary
                    if let jsonData = value.data(using: String.Encoding.utf8) {
            do {
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                if let meta = json["meta"] as? [String: Any]{
                    let pagination = meta["pagination"] as! Dictionary<String,Any>
                    let page = pagination["links"] as! Dictionary<String,Any>
                    let next = page["next"] as! String
                    nextUrl = next
                                        
                }

                            if let arr = json["data"] as? [[String: Any]] {
                                DispatchQueue.main.async {
                                    userList = arr
                                    usersTableView.reloadData()
                                }
                                debugPrint(arr)
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
    // MARK: TableView Delegate and Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        let user = userList[indexPath.row]
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.textLabel?.text = (user["name"]!) as! String
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userList[indexPath.row] as Dictionary<String,Any>
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "createUserVC") as! CreateUserViewController
        vc.userDetails = user
        vc.isEditMode = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
