//
//  BBMetalBulgeFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 8/16/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import UIKit

/// Creates a bulge distortion on the image
public class BBMetalPixellatePositionFilter: BBMetalBaseFilter {
    /// The center of the image (in normalized coordinates from 0 - 1.0) about which to distort, with a default of (0.5, 0.5)
    public var center: BBMetalPosition
    
    /// The radius from the center to apply the distortion, with a default of 0.25
    public var radius: Float
    
    /// How large the pixels are, as a fraction of the width of the image (0.0 ~ 1.0, default 0.05)
    public var fractionalWidth: Float
    
    public init(center: BBMetalPosition = .center, radius: Float = 0.25, fractionalWidth: Float = 0.05) {
        self.center = center
        self.radius = radius
        self.fractionalWidth = fractionalWidth
        super.init(kernelFunctionName: "PixellatePositionKernel")
    }
    
    public func setCenter(center: BBMetalPosition) {
        self.center = center
    }
    
    public func setRadius(radius: Float) {
        self.radius = radius
    }
    
    public func setFractional(fractional: Float) {
        self.fractionalWidth = fractional
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&center, length: MemoryLayout<BBMetalPosition>.size, index: 0)
        encoder.setBytes(&radius, length: MemoryLayout<Float>.size, index: 1)
        encoder.setBytes(&fractionalWidth, length: MemoryLayout<Float>.size, index: 2)
    }
}
