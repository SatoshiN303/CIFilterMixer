//
//  AmountSettingViewController.swift
//  CIFilterMixer
//
//  Created by 佐藤 慎 on 2020/06/26.
//  Copyright © 2020 STSN. All rights reserved.
//

import UIKit

class AmountSettingViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    
    private var image: UIImage?
    private var filter: CIFilter?
    
    private var value: Float = 5 {
        didSet {
            self.slider.value = self.value
            self.label.text = String(self.slider.value)
        }
    }
    
    private var afterDismiss: ((_ uiImage: UIImage?, _ value: Float, _ filterName: String) -> Void)? = nil
    
    // MARK: - Initializer
    
    static func makeInstance(image: UIImage?,
                             filter: CIFilter,
                             dismissHandler: @escaping ((_ uiImage: UIImage?, _ value: Float, _ filterName: String) -> Void) )
        -> AmountSettingViewController {
            guard let vc = UIStoryboard.makeInitialViewController(storyboardName: "Amount") as? AmountSettingViewController else {
                fatalError()
            }
            vc.image = image
            vc.filter = filter
            vc.afterDismiss = dismissHandler
            return vc
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.image
        self.value = 5.0
    }
    
    // MARK: - IBAction
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true) {
            if let afterDismiss = self.afterDismiss, let filter = self.filter {
                afterDismiss(self.imageView.image,
                             Float(self.value),
                             String(describing: type(of: filter)))
            }
        }
    }
    
    @IBAction func valueChange(_ sender: UISlider) {
        self.value = sender.value
    }
    
    @IBAction func valueChangeDone(_ sender: UISlider) {
        self.imageView.image = FilterHelper.amountFilter(filter: self.filter,
        originImage: image,
        amount: self.value)
    }
    
}
