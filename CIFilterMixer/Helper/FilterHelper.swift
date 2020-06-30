//
//  FilterHelper.swift
//  CIFilterMixer
//
//  Created by 佐藤 慎 on 2020/06/26.
//  Copyright © 2020 STSN. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct RGBColor {
    var red: Float
    var green: Float
    var blue: Float
}

enum CubeDimension: Int {
    case thirtyTwo = 32
    case sixtyFour = 64
}

class FilterHelper {
    
    // MARK: - Public
    
    static func filter(filter: CIFilter?,
                       originImage: UIImage?,
                       color1: UIColor?,
                       color2: UIColor?) -> UIImage? {
        guard
            let filter = filter,
            let image = originImage,
            let color1 = color1
        else {
            return originImage
        }
        
        let ciImage = CIImage(image: image)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        let ciColor = CIColor(color: color1)
        
        if filter is CIColorMonochrome {
            filter.setValue(ciColor , forKey: "inputColor")
        } else if filter is CIFalseColor {
            filter.setValue(ciColor , forKey: "inputColor0")
            if let color2 = color2 {
                let ciColor2 = CIColor(color: color2)
                filter.setValue(ciColor2, forKey: "inputColor1")
            }
        }
        
        return FilterHelper.outputImage(from: filter)
    }
    
    static func colorCubeFilter(filter: CIFilter?,
                                originImage: UIImage?,
                                color: RGBColor) -> UIImage? {
        guard
            let filter = filter,
            let image = originImage
        else {
            return originImage
        }
        
        let ciImage = CIImage(image: image)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Allocate and opulate color cube table
        let dimension: CubeDimension = .sixtyFour
        let data = FilterHelper.identityCubeData(withDimension: dimension,
                                                 color: color)
        
        // Put the table in a data object and create the filter
        filter.setValue(dimension.rawValue, forKey: "inputCubeDimension")
        filter.setValue(data, forKey: "inputCubeData")
        
        if filter is CIColorCubeWithColorSpace {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            filter.setValue(colorSpace, forKey: "inputColorSpace")
        }
        
        return FilterHelper.outputImage(from: filter)
    }
    
    static func blurFilter(filter: CIFilter?,
                           originImage: UIImage?,
                           radius: Float) -> UIImage? {
        guard
            let blurFilter = filter,
            let image = originImage else {
            return originImage
        }
        return FilterHelper.simpleFilter(filter: blurFilter,
                                         image: image,
                                         value: radius,
                                         keys: ["inputRadius"])
    }
    
    static func amountFilter(filter: CIFilter?,
                             originImage: UIImage?,
                             amount: Float) -> UIImage? {
        guard
            let amountFilter = filter,
            let image = originImage else {
            return originImage
        }
        return FilterHelper.simpleFilter(filter: amountFilter,
                                         image: image,
                                         value: amount,
                                         keys: ["inputAmount"])
    }
    
    // MARK: - Private 
        
    private static func simpleFilter(filter: CIFilter,
                                     image: UIImage,
                                     value: Float,
                                     keys: [String]) -> UIImage? {
        let ciImage = CIImage(image: image)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        for key in keys {
            filter.setValue(NSNumber(value: value), forKey: key)
        }
        
        return FilterHelper.outputImage(from: filter)
    }
    
    private static func outputImage(from filter: CIFilter) -> UIImage? {
        guard
            let outputImage = filter.outputImage,
            let result = FilterHelper.convertUIImage(from: outputImage)
        else {
            return nil
        }
        return result
    }
    
    private static func convertUIImage(from ciImage: CIImage) -> UIImage? {
        let size = ciImage.extent.size
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: .zero, size: size)
        let uiImage = UIImage(ciImage: ciImage)
        uiImage.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    // MARK: - Cube Data Creation
    
    /*
     https://github.com/danlozano/Filtr/blob/358d8a36a7ca7b86499ecc5ace8b04b90381f2a0/Filtr/Classes/LUTConverter.swift
     https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIColorCube
     */
     
    private static func identityCubeData(withDimension cubeDimension: CubeDimension,
                                        color: RGBColor) -> Data? {
        let dimension: Int = cubeDimension.rawValue
        let cubeSize = (dimension * dimension * dimension * MemoryLayout<Float>.size * 4)
        let cubeData = UnsafeMutablePointer<Float>.allocate(capacity: cubeSize)
        
        var rgb: [Float] = [0, 0, 0]
        
        var offset = 0
        for z in 0 ..< dimension {
            rgb[2] = Float(z) / Float(dimension) // blue value
            for y in 0 ..< dimension {
                rgb[1] = Float(y) / Float(dimension) // green value
                for x in 0 ..< dimension {
                    rgb[0] = Float(x) / Float(dimension) // red value
                    cubeData[offset]   = rgb[0] * color.red
                    cubeData[offset+1] = rgb[1] * color.green
                    cubeData[offset+2] = rgb[2] * color.blue
                    cubeData[offset+3] = 1.0
                    offset += 4
                }
            }
        }

        return Data(bytesNoCopy: cubeData, count: cubeSize, deallocator: .free)
    }
    
}
