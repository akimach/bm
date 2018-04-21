//
//  ViewController.swift
//  LT_Timer
//
//  Created by akimach on 2018/04/21.
//  Copyright © 2018年 akimach. All rights reserved.
//

import Cocoa
import Alamofire
import Swifter

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let server = HttpServer()
        server["/"] = {
            let url = URL(string: "http://raspberrypi.local/")
            let request = URLRequest(url: url!, timeoutInterval: 5)
            Alamofire.request(request).responseString { (res) in
                print(res)
            }
            return .ok(.html("You asked for \($0)"))
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        do {
            try server.start(8080, forceIPv4: true)
            print("Server has started ( port = \(try server.port()) ). Try to connect now...")
            semaphore.wait()
        } catch {
            print("Server start error: \(error)")
            semaphore.signal()
        }
    }

    override var representedObject: Any? {
        didSet {
        }
    }


}

