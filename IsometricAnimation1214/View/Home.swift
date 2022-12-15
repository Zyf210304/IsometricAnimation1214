//
//  Home.swift
//  IsometricAnimation1214
//
//  Created by 张亚飞 on 2022/12/14.
//

import SwiftUI

struct Home: View {
    @State var animate: Bool = false
    
    @State var b: CGFloat = 0
    @State var c: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 20, content: {
            IsomertricView(depth: animate ? 15 : 0) {
                ImageView()
            } bottom: {
                ImageView()
            } side: {
                ImageView()
            }
            .frame(width: 180, height: 330)
            .modifier(CustomProjection(b: b, c: c))
            .rotation3DEffect(.init(degrees: animate ? 45 : 0), axis: (x: 0, y: 0, z: 1))
            .scaleEffect(0.75)
            .offset(x: animate ? 12 : 0)
            
            VStack(alignment: .leading, spacing: 25) {
                Text("Isometric Transform's")
                    .font(.title.bold())
                
                HStack {
                    Button("Animate") {
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                            animate = true
                            b = -0.2
                            c = -0.3
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    
                    
                    Button("Animate slow") {
                        withAnimation(.easeIn(duration: 1)) {
                            animate = true
                            b = -0.2
                            c = -0.3
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    
                    Button("Reset") {
                        
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                            animate = false
                            b = 0
                            c = 0
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 15)
            .padding(.top, 20)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

    }
    
    @ViewBuilder
    func ImageView() -> some View{
        Image("bg")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 180, height: 330)
            .clipped()
    }
}

struct CustomProjection: GeometryEffect {
    var b: CGFloat
    var c: CGFloat
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            return AnimatablePair(b, c)
        }
        set {
            b = newValue.first
            c = newValue.second
        }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        return .init(.init(1, b, c, 1, 0, 0))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


struct IsomertricView<Content: View, Bottom: View, Side: View> : View {
    
    var content: Content
    var bottom: Bottom
    var side: Side
    
    var depth: CGFloat
    
    init(depth: CGFloat,@ViewBuilder content: @escaping() -> Content, @ViewBuilder bottom: @escaping() -> Bottom, @ViewBuilder side: @escaping() -> Side) {
        self.depth = depth
        self.content = content()
        self.bottom = bottom()
        self.side = side()
    }
    
    var body: some View {
        Color.clear
            .overlay {
                GeometryReader {
                    let size = $0.size
                    
                    ZStack {
                        content
                        DepthView(isBottom: true, size: size)
                        DepthView(isBottom: false, size: size)
                    }
                    .frame(width: size.width, height: size.height)
                }
            }
    }
    
    
    @ViewBuilder
    func DepthView(isBottom:Bool = false, size: CGSize) -> some View {
        ZStack {
            if isBottom {
                bottom
                    .scaleEffect(y: depth, anchor: .bottom)
                    .frame(height: depth, alignment: .bottom)
                    .overlay(content: {
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .blur(radius: 2.5)
                    })
                    .clipped()
                    .projectionEffect(.init(.init(1, 0, 1, 1, 0, 0)))
                    .offset(y: depth)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                side
                    .scaleEffect(x: depth, anchor: .trailing)
                    .frame(width: depth, alignment: .trailing)
                    .overlay(content: {
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .blur(radius: 2.5)
                    })
                    .clipped()
                    .projectionEffect(.init(.init(1, 1, 0, 1, 0, 0)))
                    .offset(x: depth)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
 
