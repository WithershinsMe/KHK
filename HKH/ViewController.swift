//
//  ViewController.swift
//  HKH
//
//  Created by GK on 2018/8/8.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        guard let animationVC = storyboard?.instantiateViewController(withIdentifier: "AnimationViewController") as? AnimationViewController else {
            return
        }
        animationVC.backImage = view.makeSnapshot()
        animationVC.sourceData = self
        if let tabbar = tabBarController?.tabBar {
            animationVC.tabbarImage = tabbar.makeSnapshot()
        }
        present(animationVC, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: AnimationSourceDataDelegate {
    var originatingFrameInWindow: CGRect {
        let windowRect = view.convert(bottomView.frame, to: nil)
        return windowRect
    }
    
    var originatingCoverImageView: UIImageView {
        return thumbImage
    }
    
    
}
