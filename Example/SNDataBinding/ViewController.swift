//
//  ViewController.swift
//  SNDataBinding
//
//  Created by ahmedAlmasri on 09/17/2018.
//  Copyright (c) 2018 ahmedAlmasri. All rights reserved.
//

import UIKit
import SNDataBinding

@objcMembers
 class TestModel: Bindable {
  var name: String = ""
   var Placeholder = "test"
    init(name: String ) {
        self.name = name
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let testModel = TestModel(name: "Ahmad")
        self.view.bind(withObject: testModel.toDictionary())
        testModel.name = "ali"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

