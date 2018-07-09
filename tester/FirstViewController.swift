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
    }

    @IBAction func button2Pressed(_ sender: Any) {
        
//        let obs = Observable<Any>.never()
//        let dis = obs.subscribe(onNext: {element in
//            print(element)},
//                onCompleted: {print("completed observe")})
//        print("type(of: dis): \(type(of: dis))")
//        dis.dispose()
        
        let disposeBag = DisposeBag()
        Observable<String>.create({ obs in
            obs.onNext("R2-D2")
            obs.onNext("BBBB")
            obs.onError(VendingMachineError.outOfStock)
            obs.onNext("CCCC")
//            obs.onCompleted()
            
            return Disposables.create()
        }).subscribe(onNext: {e in print(e)},
                     onError: {print("Error: \($0)")},
                     onCompleted: { print("completed")},
                     onDisposed: {print("disposed")}) //.disposed(by: disposeBag)

        
        print("end of button3")
    
    }
    
    func raiseError() throws {
//        throw VendingMachineError.outOfStock
//        let e = NSError.init(domain: "domainA", code: 10, userInfo: nil)
        let e = NSError.init()
//        e.localizedDescription = "aaa"
        throw e
    }

    @IBAction func button1Pressed(_ sender: Any){
        do {
            print("do stuff")
            try raiseError()
        }
//        catch String {
//            print(error)
//        }
//        catch VendingMachineError.outOfStock  {
//            print(error)
//        }
            
        catch {
            if let err = error as? String {
                print(err)
            }
            else {
                print("error: \(error)")
//                print("type of error : \(type(of: error))")
//                let err = "\(error.localizedDescription)"
//                print("the error as string: \(err)")
//                print("type of err : \(type(of: err))")
            }
        }
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

