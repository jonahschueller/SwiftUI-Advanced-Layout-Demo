//
//  ContentView.swift
//  SwiftUI-Advanced-Layout-Demo
//
//  Created by Jonah Schueller on 29.10.24.
//

import SwiftUI

struct ContentView: View {
    @State private var unsplash = UnsplashViewModel()


    var body: some View {
        VStack {
            
            Text("Cached Photos: \(unsplash.photos.count)")
            
            if let photo = unsplash.currentPhoto {
                AsyncImage(url: URL(string: photo.urls.regular)) { image in
                    image.resizable()
                } placeholder: {
                    Rectangle()
                        
                }
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(.rect(cornerRadius: 25))
                Text("Fetched photo: \(photo.user.name)")
            } else {
                Text("Loading...")
            }
            
            Button(
                action: {
                    unsplash.nextPhoto()
                },
                label: {
                    Text("Fetch Photo")
                }

            ).buttonStyle(.borderedProminent)

        }
    }
}

#Preview {
    ContentView()
}
