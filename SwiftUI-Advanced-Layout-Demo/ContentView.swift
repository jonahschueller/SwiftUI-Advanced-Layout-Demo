//
//  ContentView.swift
//  SwiftUI-Advanced-Layout-Demo
//
//  Created by Jonah Schueller on 29.10.24.
//

import SwiftUI

struct ContentView: View {

    @State private var unsplash = UnsplashViewModel()
    @State private var scrollOffset: CGFloat = 0

    @State private var scrollingEnabled: Bool = true

    var body: some View {
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
        .background(.black)
        .scrollDisabled(!scrollingEnabled)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
    }

}

