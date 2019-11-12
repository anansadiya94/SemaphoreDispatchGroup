//
//  ViewController.swift
//  SemaphoreDispatchGroup
//
//  Created by Anan Sadiya on 12/11/2019.
//  Copyright © 2019 Anan Sadiya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dispatchGroupSample()
//        dispatchQueueSample()
//        dispatchSemaphoreSample()
    }
    
    func dispatchGroupSample() {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        fetchImage{ (_, _) in
            print("Hi 1")
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchImage{ (_, _) in
            print("Hi 2")
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchImage{ (_, _) in
            print("Hi 3")
            dispatchGroup.leave()
        }

        // 1
        dispatchGroup.notify(queue: .main) {
            print("OK")
        }
            
        // 2
//        dispatchGroup.wait()
//        DispatchQueue.main.async {
//          print("OK")
//        }
        
    }
    
    func dispatchQueueSample() {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async {
            dispatchGroup.enter()
            self.fetchImage{ (_, _) in
                print("Hi 1")
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            self.fetchImage{ (_, _) in
                print("Hi 2")
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            self.fetchImage{ (_, _) in
                print("Hi 3")
                dispatchGroup.leave()
            }

            dispatchGroup.notify(queue: .main) {
                print("OK")
            }
        }
        
    }
    func dispatchSemaphoreSample() {
        let dispatchGroup = DispatchGroup()
        let dispatchSemaphore = DispatchSemaphore(value: 0)

        
        fetchImage{ (_, _) in
            print("Hi 1")
            dispatchSemaphore.signal()
        }
        dispatchSemaphore.wait()
 
        fetchImage{ (_, _) in
            print("Hi 2")
            dispatchSemaphore.signal()
        }
        dispatchSemaphore.wait()

        fetchImage{ (_, _) in
            print("Hi 3")
            dispatchSemaphore.signal()
        }
        dispatchSemaphore.wait()

        dispatchGroup.notify(queue: .main) {
            print("OK")
        }
    }
    
    func fetchImage(completion: @escaping (UIImage?, Error?) -> ()) {
        guard let url = URL(string: "https://www.mundodeportivo.com/r/GODO/MD/p5/Futbol/Imagenes/2019/01/25/Recortada/20190116-636832715116351220_20190116214058813-kJMD-U4636827990rC-980x554@MundoDeportivo-Web.jpg") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            completion(UIImage(data: data ?? Data()), nil)
            
        }.resume()
    }
}

