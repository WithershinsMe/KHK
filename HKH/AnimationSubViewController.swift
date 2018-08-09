//
//  AnimationSubViewController.swift
//  HKH
//
//  Created by GK on 2018/8/9.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import UIKit

class AnimationSubViewController: UIViewController,TitleSubscriber {

    @IBOutlet weak var titleLabel: UILabel!
    var titleString: String? {
        didSet {
            configTitle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTitle()
        // Do any additional setup after loading the view.
    }

    func configTitle() {
        if let title = titleString {
            self.titleLabel.text = title
        } else {
            self.titleLabel.text = ""
        }
    }

}
