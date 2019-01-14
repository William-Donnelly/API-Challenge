//
//  DataViewController.swift
//  API Challenge
//
//  Created by The Real Kaiser on 12/14/18.
//  Copyright © 2018 William Donnelly. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var USData: UILabel!
    @IBOutlet weak var CNData: UILabel!
    
    var aqiUS = ""
    var aqiCN = ""
    var cityUSData = [String]()
    var cityCNData = [String]()
    var apikey = ""
    var chosenCountry = ""
    var chosenState = ""
    var chosenCity = ""
    
    override func viewDidLoad() {
        self.title = "City Air Quality Data"
        let query = "https://api.airvisual.com/v2/city?city=\(chosenCity)&state=\(chosenState)&country=\(chosenCountry)&key=\(apikey)"
        
        //let query = "https://api.airvisual.com/v2/city?city=Chicago&state=Illinois&country=USA&key=K9nAAfJpjcJQGDceN"
        
        countryLabel.text = "Country:     \(chosenCountry)"
        stateLabel.text = "State:     \(chosenState)"
        cityLabel.text = "City:     \(chosenCity)"
        super.viewDidLoad()
        
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                print(json)
                if json["status"] == "success" {
                    print("Success")
                    self.parse(json: json)
                    //waitForThread()
                    return
                }
            }
        }
        //self.loadError()
    }
    // Do any additional setup after loading the view,   typically from a nib.
    func waitForThread(){
        if(aqiUS == ""){
            sleep(2)
            waitForThread()
        }
        else{
            USData.text = "The American AQI value here is: \(aqiUS)"
            CNData.text = "The Chinese AQI value here is: \(aqiCN)"
        }
    }
    
    
    func parse(json: JSON) {
        print("Attempting to parse")
        /*for result in json["data"].arrayValue {
         print("Found data")*/
        //for data in json["forecasts"].arrayValue{
        // print("Found some data")
        // let aqiUS = json{"data"{"current"{"pollution"{"aqius"}}}}.stringValue
        //for result in json{"data", "current", "weather"}
        let aqiUS = json["data"]["current"]["pollution"]["aqius"].stringValue
        let aqiCN = json["data"]["current"]["pollution"]["aqicn"].stringValue
        print(aqiUS)
        print(aqiCN)
        USData.text = "The American AQI value here is: \(aqiUS)"
        CNData.text = "The Chinese AQI value here is: \(aqiCN)"
        //cityUSData.append(aqiUS)
        //cityCNData.append(aqiCN)
        //USData.text = "The American AQI value here is: \(cityUSData[0])"
        //CNData.text = "The Chinese AQI value here is: \(cityCNData[0])"
    }
    
    func loadError() {
        let alert = UIAlertController(title: "Loading Error",
                                      message: "There was a problem loading the API data.",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
