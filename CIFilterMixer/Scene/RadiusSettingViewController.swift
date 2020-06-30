//
//  RadiusSettingViewController.swift
//  CIFilterMixer
//
//  Created by 佐藤 慎 on 2020/06/26.
//  Copyright © 2020 STSN. All rights reserved.
//

import UIKit

class RadiusSettingViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!

    private var value: Int = 10 {
        didSet {
            self.label.text = String(value)
            self.imageView.image = FilterHelper.blurFilter(filter: self.filter,
                                                           originImage: self.image,
                                                           radius: Float(self.value))
        }
    }
    
    private var image: UIImage?
    private var filter: CIFilter?

    public var afterDismiss: ((_ uiImage: UIImage?, _ value: Float) -> Void)? = nil

    // MARK: - Initializer
       
    static func makeInstance(image: UIImage,
                             filter: CIFilter,
                             dismissHandler: @escaping ((_ uiImage: UIImage?, _ value: Float) -> Void) )
        -> RadiusSettingViewController {
            let vc = RadiusSettingViewController()
            vc.image = image
            vc.filter = filter
            vc.afterDismiss = dismissHandler
           return vc
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.image
        self.value = 0
        self.textField.text = String("")
    }
    
    // MARK: - IBAction

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true) {
            if self.afterDismiss != nil {
                self.afterDismiss!(self.imageView.image, Float(self.value))
            }
        }
    }
    
    @IBAction func setValue(_ sender: Any) {
        if let value = Int(self.textField.text ?? "") {
            self.value = value
        } else {
            self.label.text = "error"
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        self.value = 0
        self.textField.text = String("")
    }
}
