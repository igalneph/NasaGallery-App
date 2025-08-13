//
//  CircleProgress.swift
//  NasaGallery
//
//  Created by Igal on 06/11/2021.
//

import SwiftUI

struct CircleProgress: View {
    @State private var count = false
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            Circle()
                .stroke(LinearGradient(colors: [Color.red, Color.yellow], startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round, dash: [1, 17]))
                .frame(width: 40, height: 40)
                .rotationEffect(Angle(degrees: count ? 360 : 0))
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 2).repeatForever()) {
                        count = true
                    }
                }
        }
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgress()
    }
}
