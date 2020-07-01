//
//  CIFilterExtension.swift
//  CIFilterMixer
//
//  Created by 佐藤 慎 on 2020/07/01.
//  Copyright © 2020 STSN. All rights reserved.
//

import Foundation

import CoreImage
import CoreImage.CIFilterBuiltins

extension CIFilter {
    var name: String {
        return String(describing: type(of: self))
    }
}
