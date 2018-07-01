//
//  ViewController.swift
//  tester
//
//  Created by Yosef Shachnovsky on 03/06/2018.
//  Copyright © 2018 Yosef Shachnovsky. All rights reserved.
//

import UIKit
import RxSwift


class FirstViewController: UIViewController {
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

