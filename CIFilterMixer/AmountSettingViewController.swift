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
            self.imageView.image = FilterHelper.amountFilter(filter: self.filter, originImage: image, amount: self.value)
        }
    }
    
    private var afterDismiss: ((_ uiImage: UIImage?, _ value: Float) -> Void)? = nil
    
    // MARK: - Initializer
    
    static func makeInstance(image: UIImage, filter: CIFilter) -> AmountSettingViewController {
        let vc = AmountSettingViewController()
        vc.image = image
        vc.filter = filter
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
            if self.afterDismiss != nil {
                self.afterDismiss!(self.imageView.image, self.value)
            }
        }
    }
    
    @IBAction func valueChange(_ sender: UISlider) {
        self.value = sender.value
    }

}
