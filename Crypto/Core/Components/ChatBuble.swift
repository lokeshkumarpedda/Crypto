//
//  ChatBuble.swift
//  Crypto
//
//  Created by Lokesh on 14/02/22.
//

import SwiftUI



struct ChatBubble: Shape {
    
    // 1.
    func path(in rect: CGRect) -> Path {
        // 2.
        var path = Path()
        // 3.
        let bottomLeftCorner = CGPoint(x: rect.minX, y: rect.maxY * 0.8)
        path.move(to: bottomLeftCorner)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.2))
        path.addQuadCurve(to: CGPoint(x: rect.maxX * 0.2, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.6, y: rect.minY))
        
        path.addQuadCurve(to: CGPoint(x: rect.maxX * 0.8, y: rect.maxY * 0.2), control: CGPoint(x: rect.maxX * 0.8 , y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.maxX * 0.8, y: rect.maxY * 0.8))
        path.addQuadCurve(to: CGPoint(x: rect.maxX * 0.6, y: rect.maxY), control: CGPoint(x: rect.maxX * 0.8, y: rect.maxY))
        
        path.addLine(to: CGPoint(x: rect.maxX * 0.2, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY * 0.8), control: CGPoint(x: rect.minX, y: rect.maxY))
        
        
        path.move(to: CGPoint(x: rect.maxX * 0.8, y: rect.maxY * 0.75))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.2, y: rect.maxY * 0.85))
        return path
    }
}
struct ChatBuble: View {
    var body: some View {
        ZStack{
        ChatBubble()
                .foregroundColor(Color.init(#colorLiteral(red: 0.007843137255, green: 0.6235294118, blue: 0.3137254902, alpha: 1)))
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.headline)
                .foregroundColor(.white)
                .offset(x: -4, y: 0)
            VStack{
                HStack{
                    Spacer()
                    Circle()
                        .frame(width: 10, height: 10)
                        .offset(x: -5, y: -5)
                        .foregroundColor(.red)
                }
                Spacer()
            }
        }.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
}

struct ChatBuble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBuble()
            .frame(width: 45, height: 45)
            .previewLayout(.sizeThatFits)
    }
}
