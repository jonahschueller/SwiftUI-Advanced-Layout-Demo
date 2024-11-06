//
//  PhotoView.swift
//  SwiftUI-Advanced-Layout-Demo
//
//  Created by Jonah Schueller on 30.10.24.
//

import SwiftUI

struct PhotoView: View {

    var unsplash: UnsplashViewModel

    var photo: Photo

    @State var isExpanded: Bool = false

    @State private var modalOffset: CGFloat = 0  // Offset for the modal position
    @State private var dragOffset: CGFloat = 0  // Offset during drag gesture

    var body: some View {
        GeometryReader { pageSize in
            let pageHeight = pageSize.size.height

            let modalHeight = pageHeight * 0.75

            let collapsedOffset = modalHeight * 0.75
            let expandedOffset = modalHeight * 0.05

            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: photo.urls.regular)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: pageSize.size.width,
                            height: pageSize.size.height
                        )
                        .clipped()
                } placeholder: {
                    Color.black
                }
                
                

                VStack(alignment: .leading, spacing: 5) {

                    HStack {
                        Spacer()
                        Capsule()
                            .frame(width: 35, height: 5)
                        Spacer()
                    }

                    HStack {
                      
                        
                        Text(
                            photo.user.name
                        )
                        .font(.system(size: 24, weight: .semibold))
                        .lineLimit(1)

                        Spacer()
                    }.padding(.bottom)

                    if let bio = photo.user.bio {
                        Text(bio)
                            .font(.system(size: 16, weight: .regular))
                            .lineLimit(3)
                    }

                    HStack {
                        Text(self.dateFromString(photo.createdAt))
                            .font(.caption)
                    }

                    Spacer(minLength: expandedOffset)
                }
                .padding()
                .frame(
                    width: pageSize.size.width,
                    height: modalHeight
                )
                .background(.thinMaterial)
                .cornerRadius(16)
                .offset()
                .shadow(radius: 10)
                .offset(y: max(0, modalOffset + dragOffset))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            // Calculate new position with drag
                            let newOffset =
                                modalOffset + gesture.translation.height

                            // Limit the offset to the closed and open positions
                            if newOffset >= 0 {
                                dragOffset = gesture.translation.height
                            }
                        }
                        .onEnded { gesture in
                            // Update modalOffset and reset dragOffset
                            modalOffset += dragOffset
                            dragOffset = 0

                            let predictedOffset = gesture
                                .predictedEndTranslation.height
                            let predictedNewOffset =
                                modalOffset + predictedOffset

                            // Snap to open or closed position
                            let snapThreshold =
                                (collapsedOffset - expandedOffset) / 2
                            withAnimation(.spring(duration: 0.25)) {
                                if predictedNewOffset < snapThreshold {
                                    modalOffset = expandedOffset
                                } else {
                                    modalOffset = collapsedOffset
                                }
                            }
                        }
                )
                .onAppear {
                    // Initial collapsed position
                    modalOffset = collapsedOffset
                }

            }.frame(
                width: pageSize.size.width, height: pageSize.size.height
            )
        }
    }

    func dateFromString(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .medium  // Medium style like "Nov 4, 2023"
            outputFormatter.timeStyle = .short

            let readableDate = outputFormatter.string(from: date)

            return readableDate
        } else {
            return "-"
        }
    }
}

struct NameTextSize: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
