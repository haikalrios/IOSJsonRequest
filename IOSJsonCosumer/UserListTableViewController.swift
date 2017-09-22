//
//  UserListTableViewController.swift
//  IOSJsonCosumer
//
//  Created by HC5MAC12 on 21/09/17.
//  Copyright © 2017 IESB. All rights reserved.
//

import UIKit

struct User: Codable {
    var id: Int
    var name: String
    var username: String
   
}

class UserListTableViewController: UITableViewController, URLSessionDataDelegate {
    
    var dataReceived =  Data()
    var users = [User]()
    
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        dataReceived.append(data)
    }
    
   
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let decoder = JSONDecoder()
        do {
            users = try decoder.decode([User].self, from: dataReceived)
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }catch  {
            debugPrint(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.networkServiceType = .default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.isDiscretionary = true
        config.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 1200, diskPath: NSTemporaryDirectory())
        
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        queue.maxConcurrentOperationCount = 5
        queue.underlyingQueue =  DispatchQueue.global()
        
        let session = URLSession(configuration: config,
                                 delegate: self,
                                 delegateQueue: queue)
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/users"){
            var request = URLRequest(url: url)
            request.timeoutInterval = 10
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let dataTask = session.dataTask(with: request)
            dataTask.resume()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.username
    
        return cell
    }
  
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

