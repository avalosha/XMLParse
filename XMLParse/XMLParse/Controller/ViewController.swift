//
//  ViewController.swift
//  XMLParse
//
//  Created by Álvaro Ávalos Hernández on 6/12/19.
//  Copyright © 2019 Álvaro Ávalos Hernández. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var foods = [Food]()
    var thisFood = ""
    var currentFood = Food()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let path = Bundle.main.url(forResource: "food", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    //MARK: - TableView Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let title = cell.viewWithTag(10) as! UILabel
        let price = cell.viewWithTag(11) as! UILabel
        let description = cell.viewWithTag(12) as! UILabel
        
        let food = foods[indexPath.row]
        title.text = food.name
        price.text = food.price
        description.text = food.description
        
        return cell
    }

    //MARK: - XML Parse Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        thisFood = elementName
 
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if data.count != 0 {
            switch thisFood {
            case "name":
                currentFood.name = data
                break
            case "price":
                currentFood.price = data
                break
            case "description":
                currentFood.description = data
                break
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "food"{
            foods.append(currentFood)
        }
    }
}

