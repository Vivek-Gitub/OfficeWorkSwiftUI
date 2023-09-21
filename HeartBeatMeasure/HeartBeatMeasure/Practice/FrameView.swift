//
//  FrameView.swift
//  HeartBeatMeasure
//
//  Created by Vivek Patel on 20/09/23.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    
    private let label = Text("frame")
    
    var body: some View {
        if let image = image {
          GeometryReader { geometry in
            Image(image, scale: 1.0, orientation: .upMirrored, label: label)
              .resizable()
              .scaledToFill()
              .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .center)
              .clipped()
          }
        } else {
          EmptyView()
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
