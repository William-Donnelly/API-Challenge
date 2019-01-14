//
//  StatesViewController.swift
//  API Challenge
//
//  Created by The Real Kaiser on 12/14/18.
//  Copyright © 2018 William Donnelly. All rights reserved.
//

import UIKit

class StatesViewController: UITableViewController {

    var states = [[String:String]]()
    var chosenCountry = ""
    var apikey = ""
    
    override func viewDidLoad() {
        self.title = "Choose a State"
        let query = "https://api.airvisual.com/v2/states?country=\(chosenCountry)&key=\(apikey)"
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInitiated).async {
            [unowned self] in
            if let url = URL(string: query) {
                if let data = try? Data(contentsOf: url) {
                    let json = try! JSON(data: data)
                    if json["status"] == "success" {
                        self.parse(json: json)
                        return
                    }
                }
            }
            self.loadError()
        }
        // Do any additional setup after loading the view,   typically from a nib.
    }
    
    func parse(json: JSON) {
        for result in json["data"].arrayValue {
            let name = result["state"].stringValue
            let source = ["name": name]
            states.append(source)
        }
        DispatchQueue.main.async {
            [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    func loadError() {
        DispatchQueue.main.async {
            [unowned self] in
            let alert = UIAlertController(title: "Loading Error",
                                          message: "There was a problem loading the API data.",
                                          preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        let source = states[indexPath.row]
        cell.textLabel?.text = source["name"]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! CitiesViewController
        let index = tableView.indexPathForSelectedRow?.row
        let state = states[index!]
        dvc.chosenState = state["name"]!
        dvc.chosenCountry = chosenCountry
        dvc.apikey = apikey
    }
}
