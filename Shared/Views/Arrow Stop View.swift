//
//  Arrow Stop View.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/22/25.
//

import SwiftUI

struct ArrowStopView: View {
    var arrowColor: Color
    var time: String
    
    var body: some View {
        VStack {
            Text(time)
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                let circleSize = size * 0.2
                
                ZStack {
                    Circle()
                        .fill(arrowColor)
                        .frame(width: circleSize, height: circleSize)
                        .offset(x: -size * 0.8)
                    
                    // Empty Circle (middle)
                    Circle()
                        .stroke(arrowColor, lineWidth: 3)
                        .frame(width: circleSize, height: circleSize)
                    
                    Path { path in
                        let startX = size * 0.3
                        let endX = size * 1.9
                        let midY = size * 0.5
                        
                        // Line
                        path.move(to: CGPoint(x: startX, y: midY))
                        path.addLine(to: CGPoint(x: endX, y: midY))
                        
                        // Arrowhead
                        path.move(to: CGPoint(x: endX, y: midY))
                        path.addLine(to: CGPoint(x: endX - 8, y: midY - 8))
                        
                        path.move(to: CGPoint(x: endX, y: midY))
                        path.addLine(to: CGPoint(x: endX - 8, y: midY + 8))
                    }
                    .stroke(arrowColor, lineWidth: 3)
                    
                    Circle()
                        .stroke(.white, lineWidth: 3)
                        .frame(width: circleSize * 0.5, height: circleSize)
                }
            }
            .frame(width: 100, height: 50)
        }
    }
}

#Preview {
    ArrowStopView(arrowColor: .red, time: "1:20")
}
