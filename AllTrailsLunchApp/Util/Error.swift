//
//  Error.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 7/4/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import Foundation

protocol AppError: Error {
    var title: String { get }
    var message: String? { get }
}

extension AppError {

    func describeSelf() {
        if let message = message {
            NSLog("\(title): \(message)")
        } else {
             NSLog("\(title)")
        }
    }
}


struct ClientError: AppError {
    let status: Int
    let code: String?
    let title: String
    let message: String?
    let exception: String?
    let error: String?
    
    init(status: Int, title: String, message: String? = nil, exception: String? = nil, error: String? = nil, code: String? = nil) {
        self.status = status
        self.code = code
        self.title = title
        self.message = message
        self.exception = exception
        self.error = error
    }
}

struct InternalError: AppError {
    let code: String?
    let title: String
    let message: String?
    let exception: String?
    let error: String?
    
    init(title: String, message: String? = nil, exception: String? = nil, error: String? = nil, code: String? = nil) {
        self.code = code
        self.title = title
        self.message = message
        self.exception = exception
        self.error = error
    }
}

func assertMainThread(_ message: String) {
    if !Thread.current.isMainThread {
        NSLog(message)
    }
    assert(Thread.current.isMainThread, message)
}
