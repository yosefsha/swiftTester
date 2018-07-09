//
//  LogModels.swift
//  tester
//
//  Created by Yosef Shachnovsky on 09/07/2018.
//  Copyright © 2018 Yosef Shachnovsky. All rights reserved.
//

import Foundation

protocol LoggingDelegate {
   func info(_ message: @autoclosure () -> Any, _ file: String)
}

extension LoggingDelegate {
    func info(_ message: @autoclosure () -> Any, _ file: String = #file) {
        info(message, file)
    }
}

class LogUser {
    func dostuff() {
        let a: LogManager = LogManager()
        a.info("message")
    }
}


class LogManager: LoggingDelegate {
    let logger:LogImplementation = LogImplementation()
    
    func info(_ message: @autoclosure () -> Any, _ file: String)  {
       LogImplementation.info(message,file)
    }
}



class OrcamLogger {
    static var delegate:LoggingDelegate?
    public static func info(_ message: String) {
        delegate?.info(message)
    }
}

class AnotherLogUser {
    func dostuffWithOrcamLogger() {
        OrcamLogger.info("hi from another user")
    }
}


class LogImplementation {
    class func info(_ message: @autoclosure () -> Any, _ file: String = #file ) {
        if let str = message() as? String {
            print("doing suff with message \(str) from file \(file)")
        }
    }
}



