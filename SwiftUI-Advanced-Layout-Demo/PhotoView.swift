//
//  PhotoView.swift
//  SwiftUI-Advanced-Layout-Demo
//
//  Created by Jonah Schueller on 30.10.24.
//

import SwiftUI

let OFFSET_X: CGFloat = 32
let OFFSET_Y: CGFloat = 32

let PADDING: CGFloat = 16

struct PhotoView: View {

    var photo: Photo

    @State var isExpanded: Bool = false
    @State private var nameTextSize: CGSize = .zero

    var body: some View {
        GeometryReader { pageSize in
            let MODAL_WIDTH = pageSize.size.width - OFFSET_X * 2
            let MODAL_WIDTH_INNER = MODAL_WIDTH - PADDING * 2  // With padding

            ZStack(alignment: isExpanded ? .center : .bottomLeading) {
                AsyncImage(url: URL(string: photo.urls.full)) { image in
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
                    Text(photo.user.name)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)
                        .fixedSize()
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

                            print("Name Text Size: \(size)")
                        }

                    
                    Text(photo.user.bio ?? "No Bio")
                        .font(.system(size: 12, weight: .medium))
                            .opacity(photo.user.bio == nil ? 0.75 : 1)
                            .lineLimit(5)
                            .frame(
                                width: MODAL_WIDTH_INNER,
                                alignment: .leading
                            )
                            .fixedSize()
                            .opacity(isExpanded ? 1 : 0)
                    

                    Text(photo.createdAt.dateFromString())
                        .font(.caption)
                        .frame(width: MODAL_WIDTH_INNER,
                               alignment: .leading)
                        .fixedSize()
                        .opacity(isExpanded ? 1 : 0)

                    if isExpanded {
                        Spacer()
                    }

                }
                .padding(PADDING)
                .frame(
                    minWidth: isExpanded
                        ? MODAL_WIDTH : 0,
                    maxWidth: isExpanded
                        ? MODAL_WIDTH : nameTextSize.width + 2 * PADDING,
                    maxHeight: isExpanded
                        ? pageSize.size.height * 0.7
                        : nameTextSize.height + 2 * PADDING,
                    alignment: .topLeading
                )
                .background(.thinMaterial)
                .clipShape(
                    RoundedRectangle(cornerRadius: nameTextSize.height)
                )
                .offset(
                    x: isExpanded ? 0 : OFFSET_X,
                    y: isExpanded ? 0 : -OFFSET_Y
                )
                .onTapGesture {
                    withAnimation(.spring(duration: 2, bounce: 0.25)) {
                        isExpanded.toggle()
                    }
                }
            }.frame(
                width: pageSize.size.width, height: pageSize.size.height
            )
        }
    }
}

struct NameTextSize: PreferenceKey {
    static var defaultValue: CGSize { .zero }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
