//
//  ContentView.swift
//  SwiftUI-Advanced-Layout-Demo
//
//  Created by Jonah Schueller on 29.10.24.
//

import SwiftUI

enum AnimationSpeed: CGFloat {
    case slow = 5
    case fast = 0.4
}

struct ContentView: View {

    @State private var unsplash = UnsplashViewModel()
    @State private var scrollOffset: CGFloat = 0

    @State private var scrollingEnabled: Bool = true

    @State private var animationSpeed = AnimationSpeed.fast
    @State private var animationSpeedDidChange: Bool = false

    var body: some View {
        ZStack {
            GeometryReader { screen in
                ScrollView {
                    LazyVStack(spacing: 0) {

                        ForEach(
                            Array(unsplash.photos.enumerated()),
                            id: \.offset
                        ) {
                            index,
                            item in
                            PhotoView(
                                photo: item,
                                scrollingEnabled: $scrollingEnabled
                            )
                            .frame(
                                width: screen.size.width,
                                height: screen.size.height
                            )
                            .onAppear {
                                // Get new photos while scrolling
                                if index > 0
                                    && index == self.unsplash.photos.count
                                        - 2
                                {
                                    print(
                                        "Reached the end! Fetching more photos..."
                                    )
                                    self.unsplash.fetchNextBatch()
                                }
                            }
                        }
                    }
                }
            }

            HStack {
                Image(
                    systemName: animationSpeed == .fast
                        ? "hare.fill" : "tortoise.fill"
                ).contentTransition(.symbolEffect)

                Text(animationSpeed == .fast ? "Fast" : "Slow")
            }.padding()
                .font(.system(size: 16, weight: .semibold))
                .background(.thinMaterial)
                .cornerRadius(32)
                .opacity(animationSpeedDidChange ? 1 : 0)

        }
        .onTapGesture(
            count: 2,
            perform: self.toggleAnimationSpeed
        )
        .background(.black)
        .scrollDisabled(!scrollingEnabled)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
        .environment(\.animationSpeed, animationSpeed.rawValue)
    }

    func toggleAnimationSpeed() {
        if animationSpeedDidChange {
            return
        }
        
        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
        impactMed.impactOccurred()

        withAnimation {
            if animationSpeed == .fast {
                animationSpeed = .slow
            } else {
                animationSpeed = .fast
            }
            animationSpeedDidChange.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.animationSpeedDidChange.toggle()
            }
        }
    }
}

extension EnvironmentValues {
    @Entry var animationSpeed: CGFloat = 0.4
}
