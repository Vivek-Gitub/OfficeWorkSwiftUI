//
//  CameraAccessView.swift
//  HeartBeatMeasure
//
//  Created by Vivek Patel on 21/09/23.
//

import SwiftUI

struct CameraAccessView: View {
    var body: some View {
        HostedViewController()
            .ignoresSafeArea()
    }
}

struct CameraAccessView_Previews: PreviewProvider {
    static var previews: some View {
        CameraAccessView()
    }
}
