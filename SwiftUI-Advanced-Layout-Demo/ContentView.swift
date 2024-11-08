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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { screen in
                ScrollView {
                    LazyVStack(spacing: 0) {

                        ForEach(
                            Array(unsplash.photos.enumerated()),
                            id: \.offset
                        ) { index, item in
                            PhotoView(photo: item)
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
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
        }
    }
}
