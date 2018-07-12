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


//
//  DataViewModel.swift
//  MyMeSwift
//
//  Created by Yosef Shachnovsky on 02/07/2018.
//  Copyright © 2018 Orcam. All rights reserved.



//
//  DataViewModel.swift
//  MyMeSwift
//
//  Created by Yosef Shachnovsky on 02/07/2018.
//  Copyright © 2018 Orcam. All rights reserved.
//

import Foundation

extension String: Error {}
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

enum FileError: Error{
    case fileNotFound, unreadable, encodeFailed
}

/// A collection of utility methods for common disposable operations.
//public struct Disposables {
//    private init() {}
//}

var s1:String = "s1111"
var s2:String = "s2222"
var s3:String = "s3333"

class FirstViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button2: UIButton!
    
    
    @IBAction func button3pressed(_ sender: Any) {
        
        let disposebag = DisposeBag()
        func loadText(filename: String) -> Single<String> {
            return Single.create(subscribe: { single in
                let dis = Disposables.create()
                
                guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
                    single(.error(FileError.unreadable))
                    return dis
                }
                
                guard let data = FileManager.default.contents(atPath: path) else {
                    single(.error(FileError.encodeFailed))
                    return dis
                }
                
                guard let contents = String(data:data, encoding: .utf8) else {
                    single(.error(FileError.encodeFailed))
                    return dis
                }
                
                single(.success(contents))
                
                return dis
            })
        }
        
        let r = loadText(filename: "aaa")
        print("type of loadtext return: \(type(of: r))")
            r.subscribe{
                switch $0 {
                case .success(let str):
                    print(str)
                case .error(let error):
                    print(error)
                }
        }
        .disposed(by: disposebag)
        
    }
    
    

    @IBAction func button2Pressed(_ sender: Any) {
        let disposebag = DisposeBag()
        
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        subject.onNext(useTheForce)
        
        subject.subscribe({ print(label: "1: ", event: <#T##Event<CustomStringConvertible>#>)})
        
        
    }
    
    func raiseError() throws {
//        throw VendingMachineError.outOfStock
//        let e = NSError.init(domain: "domainA", code: 10, userInfo: nil)
        let e = NSError.init()
//        e.localizedDescription = "aaa"
        throw e
    }

    @IBAction func button1Pressed(_ sender: Any){
        let disposebag = DisposeBag()
        
        let quotes = BehaviorSubject<String>(value: iAmYourFather)
        
        let sub1 = quotes.subscribe({print(label: "1: ", event: $0 )})
        
        sub1.disposed(by: disposebag)
        
        quotes.onError(Quote.neverSaidThat)
        
        quotes.subscribe({ print(label: "2:", event: $0)}).disposed(by: disposebag)
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//        myObservabel?.do(onNext: {s in print("the new val: \(s)")}
//            , onError: nil,
//              onCompleted: {print("cmpleted event received")},
//              onSubscribe: nil,
//              onSubscribed: nil,
//              onDispose: nil).subscribe().disposed(by: DisposeBag())

