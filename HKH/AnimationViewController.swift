//
//  AnimationViewController.swift
//  HKH
//
//  Created by GK on 2018/8/8.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import UIKit

protocol AnimationSourceDataDelegate: class {
    var originatingFrameInWindow: CGRect { get }
    var originatingCoverImageView: UIImageView { get }
}
class AnimationViewController: UIViewController {

    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var backingImageBottomInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageTopInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageLeadingInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageTrailingInset: NSLayoutConstraint!
    let cardCornerRadius: CGFloat = 10
    let primaryDuration = 4.0
    let backingImageEdgeInset: CGFloat = 15.0
    
    @IBOutlet weak var dismissChevron: UIButton!
    @IBOutlet weak var coverImageContainer: UIView!
    
    @IBOutlet weak var coverArtImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var coverImageContainerTopInset: NSLayoutConstraint!
    
    
    @IBOutlet weak var artImageTopInset: NSLayoutConstraint!
    
    @IBOutlet weak var artImageBottomInset: NSLayoutConstraint!
    @IBOutlet weak var artImageHeightInset: NSLayoutConstraint!
    @IBOutlet weak var artImageLeftInset: NSLayoutConstraint!
    weak var sourceData: AnimationSourceDataDelegate!
    
    @IBOutlet weak var stretchySkirt: UIView!
    
    
    @IBOutlet weak var lowerSubModuleTopInset: NSLayoutConstraint!
    
    @IBOutlet weak var bottomBarImageViewBottomInset: NSLayoutConstraint!
    @IBOutlet weak var bottomBarImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomBarImageView: UIImageView!
    
    var tabbarImage: UIImage?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var backImage: UIImage?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        modalPresentationCapturesStatusBarAppearance = true //allow this VC to control the status bar appearance
        modalPresentationStyle = .overFullScreen //dont dismiss the presenting view controller when presented

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backImageView.image = backImage
        scrollView.contentInsetAdjustmentBehavior = .never
        coverImageContainer.layer.cornerRadius = cardCornerRadius
        coverImageContainer.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureImageLayerInStartPosition()
        coverArtImage.image = sourceData.originatingCoverImageView.image
        configureCoverImageInStartPosition()
        configureLowerModuleInStartPosition()
        configureBottomSection()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateBackingImageIn()
        animateImageLayerIn()
        animateCoverImageIn()
        animateLowerModuleIn()
        animateBottomSectionOut()
    }
    @IBAction func dismissAnimation(_ sender: UITapGestureRecognizer) {
        animateBackingImageOut()
        animateCoverImageOut()
      
        animateImageLayerOut { _ in
            self.dismiss(animated: false, completion: nil)
        }
        animateLowerModuleOut()
        animateBottomSectionIn()
    }
}

extension AnimationViewController {
    func configureBottomSection() {
        if let image = tabbarImage {
            bottomBarImageViewHeight.constant = image.size.height
            bottomBarImageView.image = image
        }else {
            bottomBarImageViewHeight.constant = 0
        }
    }
    func animateBottomSectionOut() {
        if let image = tabbarImage {
            UIView.animate(withDuration: primaryDuration / 2.0) {
                self.bottomBarImageViewBottomInset.constant = -image.size.height
                self.view.layoutIfNeeded()
            }
        }
    }
    func animateBottomSectionIn() {
        if let _ = tabbarImage {
            UIView.animate(withDuration: primaryDuration / 2.0) {
                self.bottomBarImageViewBottomInset.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}
extension AnimationViewController {
    private var lowerModuleInsetForOurPosition: CGFloat {
        let bounds = view.bounds
        let inset = bounds.height - bounds.width
        return inset
    }
    
    private func configureLowerModuleInStartPosition() {
        lowerSubModuleTopInset.constant = lowerModuleInsetForOurPosition
    }
    private func animateLowerModule(isPresenting: Bool) {
        let topInset = isPresenting ? 0 : lowerModuleInsetForOurPosition
        UIView.animate(withDuration: primaryDuration, delay: 0, options: .curveEaseIn, animations: {
            self.lowerSubModuleTopInset.constant = topInset
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateLowerModuleOut() {
        animateLowerModule(isPresenting: false)
    }
    
    func animateLowerModuleIn() {
        animateLowerModule(isPresenting: true)
    }
}


//给背景添加动画 shrink

extension AnimationViewController {
    private func configureBackingImageInPosition(presenting: Bool) {
        let edgeInset: CGFloat = presenting ? backingImageEdgeInset : 0
        let dimmerAlpha: CGFloat = presenting ? 0.3 : 0
        let cornerRadius: CGFloat = presenting ? cardCornerRadius : 0
        
        backingImageLeadingInset.constant = edgeInset
        backingImageTrailingInset.constant = edgeInset
        let aspectRedio = backImageView.frame.size.height / backImageView.frame.size.width
        backingImageTopInset.constant = edgeInset * aspectRedio
        backingImageBottomInset.constant = edgeInset * aspectRedio
        
        dimmerView.alpha = dimmerAlpha
        
        backImageView.layer.cornerRadius = cornerRadius
    }
    
    private func animateBackingImage(presenting: Bool) {
        UIView.animate(withDuration: primaryDuration) {
            self.configureBackingImageInPosition(presenting: presenting)
            self.view.layoutIfNeeded()
        }
    }
    
    func animateBackingImageIn() {
        animateBackingImage(presenting: true)
    }
    
    func animateBackingImageOut() {
        animateBackingImage(presenting: false)
    }
}

//给Image 添加动画，等比例的放大
extension AnimationViewController {
    func configureCoverImageInStartPosition() {
        let originatingImageFrame = sourceData.originatingCoverImageView.frame
        artImageTopInset.constant = originatingImageFrame.minY
        artImageBottomInset.constant = originatingImageFrame.minY
        artImageLeftInset.constant = originatingImageFrame.minX
        artImageHeightInset.constant = originatingImageFrame.height
    }
    func animateCoverImageIn() {
        let artImageEdgeConstraint: CGFloat = 30
        let endHeight = coverImageContainer.bounds.width - artImageEdgeConstraint * 2
        
        UIView.animate(withDuration: primaryDuration, delay: 0, options: .curveEaseIn, animations: {
            self.artImageHeightInset.constant = endHeight
            self.artImageLeftInset.constant = artImageEdgeConstraint
            self.artImageBottomInset.constant = artImageEdgeConstraint
            self.artImageTopInset.constant = artImageEdgeConstraint
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateCoverImageOut() {
        UIView.animate(withDuration: primaryDuration, delay: 0, options: .curveEaseOut, animations: {
            self.configureCoverImageInStartPosition()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

//使得Image Container view从用户点击之处的位置开始动画
extension AnimationViewController {
    private var startColor: UIColor {
        return UIColor.white.withAlphaComponent(0.3)
    }
    private var endColor: UIColor {
        return .white
    }
    
    private var imageLayerInsetForOutPosition: CGFloat {
        let imageFrame = view.convert(sourceData.originatingFrameInWindow, to: view)
        let inset = imageFrame.minY - backingImageEdgeInset
        return inset
    }
    
    func configureImageLayerInStartPosition() {
        coverImageContainer.backgroundColor = startColor
        let startPosition = imageLayerInsetForOutPosition
        dismissChevron.alpha = 0
        coverImageContainer.layer.cornerRadius = 0
        coverImageContainerTopInset.constant = startPosition
        view.layoutIfNeeded()
    }
    
    func animateImageLayerIn() {
        UIView.animate(withDuration: primaryDuration / 4.0) {
            self.coverImageContainer.backgroundColor = self.endColor
        }
        UIView.animate(withDuration: primaryDuration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.coverImageContainerTopInset.constant = 0
            self.dismissChevron.alpha = 1
            self.coverImageContainer.layer.cornerRadius = self.cardCornerRadius
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func animateImageLayerOut(completion: @escaping ((Bool) -> Void)) {
        let endInset = imageLayerInsetForOutPosition
        
        UIView.animate(withDuration: primaryDuration / 4.0,
                       delay: primaryDuration, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.coverImageContainer.backgroundColor = self.startColor
        }) { finish in
            completion(finish)
        }
        
        UIView.animate(withDuration: primaryDuration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.coverImageContainerTopInset.constant = endInset
            self.dismissChevron.alpha = 0
            self.coverImageContainer.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
