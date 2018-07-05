//
//  Models.swift
//  tester
//
//  Created by Yosef Shachnovsky on 05/07/2018.
//  Copyright © 2018 Yosef Shachnovsky. All rights reserved.
//

import Foundation
import RxSwift

class ExampleClass {
    let disposeBag = DisposeBag()
    
    func runExample() {
        
        // OBSERVABLE //
        
        let observable = Observable<String>.create { (observer) -> Disposable in
            DispatchQueue.global(qos: .default).async {
                Thread.sleep(forTimeInterval: 10)
                observer.onNext("Hello dummy 🐣")
                observer.onCompleted()
            }
            return Disposables.create()
        }
        // OBSERVER //
        
        observable.subscribe(onNext: { (element) in
            print(element)
        }).addDisposableTo(disposeBag)
    }
}

public struct AnyDecodable: Decodable {
    public var value: Any
    
    private struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
    }
    
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            var result = [String: Any]()
            try container.allKeys.forEach { (key) throws in
                result[key.stringValue] = try container.decode(AnyDecodable.self, forKey: key).value
            }
            value = result
        } else if var container = try? decoder.unkeyedContainer() {
            var result = [Any]()
            while !container.isAtEnd {
                result.append(try container.decode(AnyDecodable.self).value)
            }
            value = result
        } else if let container = try? decoder.singleValueContainer() {
            if let intVal = try? container.decode(Int.self) {
                value = intVal
            } else if let doubleVal = try? container.decode(Double.self) {
                value = doubleVal
            } else if let boolVal = try? container.decode(Bool.self) {
                value = boolVal
            } else if let stringVal = try? container.decode(String.self) {
                value = stringVal
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing serialisable")
            }
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not serialise"))
        }
    }
}

struct OneSectionData {
    var name: String
    var cellsArray: [(String, Any)]?
    init(name: String, cellsDataDict:[String:Any]) {
        self.name = name
        self.cellsArray = cellsDataDict.sorted(by: {$0.key > $1.key})
    }
    func getNumberOfItems() -> Int{
        guard let arr = self.cellsArray else {
            return 0
        }
        return arr.count
    }
}


class DataViewModel {
    //    var dataDict: [String: Any]?
    //    var sectionsArray:[(String, [String:Any])]?
    
    var sectionsDetailedArray:[(String, [(String, [String:Any])])]?
    
    var sectionsDataArray: [OneSectionData]?
    
    func decodeData(json:String) {
        
        guard let jsonData = json.data(using: .utf8) else{
            print("could not convert to data")
            return
        }
        
        guard let decoded = try? JSONDecoder().decode(AnyDecodable.self, from: jsonData).value as! [String:Any]  else {
            print("could not decode")
            return
        }
        
        guard let arr = decoded.sorted(by: {$0.key > $1.key}) as? [(String, [String : Any])] else {
            print("could not convert to sections")
            return
        }
        
        self.sectionsDataArray = arr.map { t in OneSectionData(name:t.0, cellsDataDict:t.1) }
    }
    
    
    func getNumberOfSections() -> Int {
        guard let arr = self.sectionsDataArray else {
            return 0
        }
        return arr.count
    }
    
    func getNumberOfItemsInSection(sectionNum:Int) -> Int {
        guard let arr = self.sectionsDataArray else {
            return 0
        }
        return arr[sectionNum].getNumberOfItems()
    }
    
    func getSectionName(sectionNum:Int) -> String {
        guard let arr = self.sectionsDataArray else {
            return ""
        }
        return arr[sectionNum].name
    }
    
}
