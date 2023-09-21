//
//  FrameHandlerViewModel.swift
//  HeartBeatMeasure
//
//  Created by Vivek Patel on 20/09/23.
//

import SwiftUI

struct FrameHandlerViewModel: View {
    
    @StateObject private var model = FrameHandler()
    
    var body: some View {
        
        FrameView(image: model.frame)
            .ignoresSafeArea()
    }
}

struct FrameHandlerViewModel_Previews: PreviewProvider {
    static var previews: some View {
        FrameHandlerViewModel()
    }
}
