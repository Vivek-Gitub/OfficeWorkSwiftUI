//
//  CGImageExtension.swift
//  HeartRateMeasure
//
//  Created by Vivek Patel on 21/09/23.
//

import CoreGraphics
import VideoToolbox

extension CGImage {
  static func create(from cvPixelBuffer: CVPixelBuffer?) -> CGImage? {
    guard let pixelBuffer = cvPixelBuffer else {
      return nil
    }

    var image: CGImage?
    VTCreateCGImageFromCVPixelBuffer(
      pixelBuffer,
      options: nil,
      imageOut: &image)
    return image
  }
}
