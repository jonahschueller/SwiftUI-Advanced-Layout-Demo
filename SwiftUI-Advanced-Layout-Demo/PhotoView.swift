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

    @State var expansionWidth = CGFloat.zero
    @State var expansionHeight = CGFloat.zero

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: photo.urls.regular)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.black
            }
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height)

            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(
                        photo.user.name
                    )
                    .font(.system(size: 20, weight: .semibold))
                    .lineLimit(1)

                    Spacer(minLength: 10)

                    Button(
                        "",
                        systemImage: "chevron.down.circle.fill"
                    ) {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            self.isExpanded.toggle()
                        }
                    }
                    .rotationEffect(
                        .degrees(
                            self.isExpanded ? 180 : 0
                        )
                    )
                    .font(.system(.title)).layoutPriority(1)

                }

                if isExpanded {

                    if let bio = photo.user.bio {
                        Text(bio)
                            .lineLimit(3)
                    }

                    HStack {
                        Text(self.dateFromString(photo.createdAt))
                            .font(.caption)
                    }

                }

                Spacer()
            }
            .padding()
            .frame(
                width: expansionWidth,
                height:
                    getPercentageOfScreenHeight(isExpanded ? 0.5 : 0.1)

            )
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(
                .rect(
                    topLeadingRadius: 20,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 20
                )
            )
            .clipped()
        }.background(
            GeometryReader {
                Color.clear.preference(
                    key: ViewHeightKey.self,
                    value: $0.frame(in: .local).size.height
                )
                .preference(
                    key: ViewWidthKey.self,
                    value: $0.frame(in: .local).size.width
                )
            }
        )
        .onPreferenceChange(
            ViewWidthKey.self,
            perform: { value in
                print(
                    "Expansion \(value), Screen \(UIScreen.main.bounds.width)"
                )
                expansionWidth = value
            }
        )
        .onPreferenceChange(
            ViewHeightKey.self,
            perform: { value in
                print(value)
                expansionHeight = value
            })

    }

    func getPercentageOfScreenHeight(_ percentage: CGFloat) -> CGFloat {
        return expansionHeight * percentage
    }

    func dateFromString(_ string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        print(string)

        guard let date = formatter.date(from: string) else {
            return "TODO: Figure out the format"
        }

        let formatter2 = DateFormatter()
        formatter2.dateStyle = .medium
        return formatter2.string(from: date)
    }
}

struct ViewWidthKey: PreferenceKey {
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
