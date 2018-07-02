//
//  ViewController.swift
//  tester
//
//  Created by Yosef Shachnovsky on 03/06/2018.
//  Copyright © 2018 Yosef Shachnovsky. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


struct Employee: CustomStringConvertible {
    var description: String {
        return "name: \(self.name), id:\(self.id)"
    }
    
    var name: String
    var id: Int
    var favoriteToy: Toy
    
    enum CodingKeys: String, CodingKey {
        case id = "employeeId"
        case name
        case gift
    }
}

extension Employee: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(favoriteToy.name, forKey: .gift)
    }
}

extension Employee: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self) // values is of type Swift.KeyedDecodingContainer<tester.Employee.CodingKeys>
        name = try values.decode(String.self, forKey: .name)
        id = try values.decode(Int.self, forKey: .id)
        let gift = try values.decode(String.self, forKey: .gift)
        favoriteToy = Toy(name: gift)
    }
}

struct Toy: Codable {
    var name: String
}


// MARK cellData and Section Data structs:

struct CellData: Encodable, Decodable {
    
    var key: String
    var val: String
    
    enum CodingKeys: String, CodingKey {
        case key
        case val
    }
}

struct OneSectionData {
    
    var name: String
    var cellDataArray: Array<CellData>!
    
    init(name:String, cellsData: [CellData]) {
        self.cellDataArray = Array<CellData>()
        self.cellDataArray.insert(contentsOf: cellsData, at: 0)
        self.name = name
    }
    enum CodingKeys: String, CodingKey {
        case name
        case cellDataArray
    }
    
}

extension OneSectionData : Encodable{
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cellDataArray, forKey: .cellDataArray)
        try container.encode(name, forKey: .name)
        
    }
}

extension OneSectionData : Decodable{
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        cellDataArray = try values.decode([CellData].self, forKey: .cellDataArray)
    }
}

struct SectionsData {
    var sectionsDict: [String: OneSectionData]
    
    init(data:[String: OneSectionData]) {
        self.sectionsDict = data
    }
    
    enum CodingKeys: String, CodingKey {
        case sectionsDict = "data"
    }
}

extension SectionsData : Encodable{
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sectionsDict, forKey: .sectionsDict)
    }
}

extension SectionsData: Decodable{
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sectionsDict = try values.decode ([String:OneSectionData].self, forKey: .sectionsDict)
    }}





class FirstViewController: UIViewController {
    

    @IBOutlet var button3: UIButton!
    
    @IBAction func button3pressed(_ sender: Any) {
        let encoder = JSONEncoder()
        
        let c1 = CellData(key: "name", val: "yossi")
        let c2 = CellData(key: "name", val: "david")
        let c3 = CellData(key: "name", val: "moshe")
        let c4 = CellData(key: "name", val: "baruch")
        
        let s1 = OneSectionData(name:"sec1", cellsData: [c1,c2,c3])
        let s2 = OneSectionData(name:"sec2", cellsData: [c4])
        
        let sectionsData = ["data":[s1.name:s1, s2.name:s2]]
        
//        print("sectionsData: \(sectionsData)")
        
        do {
            let jsonData1 = try encoder.encode(sectionsData)
            if let jsonString1 = String(data: jsonData1, encoding: .utf8){
                print("json string: \(jsonString1)")
            }
                let jsonDecoder = JSONDecoder()
                let sectionsData2 = try jsonDecoder.decode(SectionsData.self, from: jsonData1)
                print("sectionsData2: \(sectionsData2)")

        }
        catch {
            print("error occured: \(error)")
        }
        
        
        
        
        
    }
    @IBOutlet var button2: UIButton!
    @IBAction func button2Pressed(_ sender: Any) {
        let encoder = JSONEncoder()
        

        let toy1 = Toy(name: "Teddy Bear")
        let employee1 = Employee(name: "John Appleseed", id: 7, favoriteToy: toy1)
        print("employee1: \(employee1)")
        do {
            let jsonData1 = try encoder.encode(employee1)
            if let jsonString1 = String(data: jsonData1, encoding: .utf8){
                print(jsonString1)
                
                let jsonDecoder = JSONDecoder()
                let employee2 = try jsonDecoder.decode(Employee.self, from: jsonData1)

                print("employee2: \(employee2)")
            }
  
        }
        catch {
            print("error occured: \(error)")
        }
        
    }
    
    @IBOutlet weak var button1: UIButton!
    @IBAction func button1Pressed(_ sender: Any){
        var albums = ["Red", "1989", "Reputation", "The whoo"]
        var randomIndex = arc4random_uniform(UInt32(albums.count))
        self.text = albums[Int(randomIndex)]
        
        print("self.text \(self.text)")
    }
    var text:String = "hello rx"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let helloSequence = Observable.of(self.text)
        
        let subscription = helloSequence.subscribe { event in
            print(event)
        }
        print("type of subscription:  \(type(of: subscription))")
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

