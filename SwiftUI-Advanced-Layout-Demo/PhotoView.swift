//
//  PhotoView.swift
//  SwiftUI-Advanced-Layout-Demo
//
//  Created by Jonah Schueller on 30.10.24.
//

import SwiftUI

let OFFSET_X: CGFloat = 32
let OFFSET_Y: CGFloat = 32

struct PhotoView: View {

    var unsplash: UnsplashViewModel

    var photo: Photo

    @State var isExpanded: Bool = false

    @State private var modalOffset: CGFloat = 0  // Offset for the modal position
    @State private var dragOffset: CGFloat = 0  // Offset during drag gesture

    @State private var nameTextSize: CGSize = .zero

    var body: some View {
        GeometryReader { pageSize in
            let pageHeight = pageSize.size.height
            let modalHeight = pageHeight * 0.75

            ZStack(alignment: .bottomLeading) {
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
                        Text(
                            photo.user.name
                        )
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)
                        .background {
                            GeometryReader { nameText in
                                Color.clear
                                    .preference(
                                        key: NameTextSize.self,
                                        value: nameText.size
                                    )
                            }
                        }.onPreferenceChange(NameTextSize.self) { size in
                            nameTextSize = size
                        }

                        Spacer()
                    }.padding(.bottom)

                    Group {

                        if let bio = photo.user.bio {
                            Text(bio)
                                .font(.system(size: 16, weight: .regular))
                                .lineLimit(3)
                        }

                        HStack {
                            Text(self.dateFromString(photo.createdAt))
                                .font(.caption)
                        }

                    }.opacity(
                        isExpanded ? 1.0 : 0.0
                    )

                    Spacer()

                }
                .padding(16)
                .frame(
                    width: pageSize.size.width,
                    height: pageSize.size.height
                )
                .background(.thinMaterial)
                .frame(
                    width: isExpanded
                        ? pageSize.size.width
                        : min(
                            nameTextSize.width + OFFSET_X,  // Preferred fitting size
                            pageSize.size.width - 2 * OFFSET_X  // Maximum available size
                        ),
                    height: isExpanded
                        ? modalHeight : nameTextSize.height + OFFSET_Y,
                    alignment: .topLeading
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: nameTextSize.height)
                )
                .offset(
                    x: isExpanded ? 0 : OFFSET_X,
                    y: isExpanded ? 0 : -OFFSET_Y
                )
                .onTapGesture {

                    withAnimation(.spring(duration: 0.4, bounce: 0.25)) {
                        isExpanded.toggle()
                    }
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
    static var defaultValue: CGSize { .zero }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
