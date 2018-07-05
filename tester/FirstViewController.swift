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




class FirstViewController: UIViewController {
    var text:String = "hello rx"
    var textList:[String] = ["aaa","bbb","cc"]
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet var button3: UIButton!
    
    @IBAction func button3pressed(_ sender: Any) {
        let scheduler = SerialDispatchQueueScheduler(qos: .default) //RxSwift.SerialDispatchQueueScheduler
        let subscription = Observable<Int>.interval(0.5, scheduler: scheduler)
            .subscribe { event in
                print(event)
                print("iscompleted: \(event.isCompleted)")
        }
        
        Thread.sleep(forTimeInterval: 2.0)
        
        subscription.dispose()
    }
    
    @IBOutlet var button2: UIButton!
    
    @IBAction func button2Pressed(_ sender: Any) {
        self.text += "a"
        print(self.text)
        
    }
//
    
    @IBAction func button1Pressed(_ sender: Any){
        var albums = ["Red", "1989", "Reputation", "The whoo"]
        var randomIndex = arc4random_uniform(UInt32(albums.count))
        self.text = albums[Int(randomIndex)]

        print("self.text \(self.text)")
    }
    
    var myObservabel:Observable<String>?
    
    //let hello = Observable.of(self.text)
    var hello: Observable<String> {
        get{
            return Observable.of(self.text)
        }
        set {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        helloSequence = Observable.of(self.text)
        myObservabel = Observable.of(self.text)
        
        let listSequence = Observable.of(self.textList)
        
        let variableText = Variable<String>("")
        let observableText = variableText.asObservable()
        
//        hello.do(
//            onNext: { value in
//
//        }
//            )
//
//        let subscription = helloSequence.subscribe { event in
//            print(event)
//        }
        
        myObservabel?.do(onNext: {s in print("the new val: \(s)")}
            , onError: nil,
              onCompleted: {print("cmpleted event received")},
              onSubscribe: nil,
              onSubscribed: nil,
              onDispose: nil).subscribe().disposed(by: DisposeBag())
        
        let secondSubscription = listSequence.subscribe { event in
            print(event)
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



