//
//  APODStarsBackgroundView.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-04-14.
//

import SwiftUI

struct APODStarsBackgroundView: View {
    let dotAmount: Int = 100
    let dotSize: CGFloat = 20 // Size of each dot
    let dotSpeed: Double = 20 // Speed of the dots
    let starsColor: Color = .yellow
    
    @State private var dotOffsets: [CGSize] = (0..<100).map { _ in
        CGSize(width: CGFloat.random(in: -100...100), height: CGFloat.random(in: -100...100))
    }
    
    var body: some View {
        VStack {
            ForEach(0..<dotAmount) { index in
                Star(corners: 5, smoothness: 0.5)
                    .fill(starsColor)
                    .frame(width: dotSize, height: dotSize)
                    .offset(dotOffsets[index])
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            // Generate random starting positions for the dots
            dotOffsets = (0..<dotAmount).map { _ in
                CGSize(width: CGFloat.random(in: -200...200), height: CGFloat.random(in: -400...400))
            }
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            // Update dot positions
            withAnimation(.linear(duration: dotSpeed)) {
                dotOffsets = dotOffsets.enumerated().map { (index, offset) in
                    let x = offset.width + CGFloat.random(in: -5...5)
                    let y = offset.height + CGFloat.random(in: -5...5)
                    return CGSize(width: x, height: y)
                }
            }
        }
    }
}
