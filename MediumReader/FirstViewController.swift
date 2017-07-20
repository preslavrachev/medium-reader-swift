//
//  FirstViewController.swift
//  MediumReader
//
//  Created by Preslav Rachev on 07/07/17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import UIKit

extension UIViewController: ContextProvider {
    var contextProvider: ContextProvider {
        return UIApplication.shared.delegate as! ContextProvider
    }
    
    var context: Context { return contextProvider.context }
}

class FirstViewController: UIViewController {
    
    var apiManager: MediumApiManager {
        return context.mediumApiManager
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        apiManager.fetchTopPosts {
            postCollection in print(postCollection)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

