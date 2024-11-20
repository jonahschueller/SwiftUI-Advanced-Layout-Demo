//
//  PhotoView.swift
//  SwiftUI-Advanced-Layout-Demo
//
//  Created by Jonah Schueller on 30.10.24.
//

import MapKit
import SwiftUI

let OFFSET_X: CGFloat = 32
let OFFSET_Y: CGFloat = 32

let PADDING: CGFloat = 16

struct NameTextSize: PreferenceKey {
    static var defaultValue: CGSize { .zero }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct PhotoView: View {

    @Environment(\.animationSpeed) var animationSpeed

    var photo: Photo

    @Binding var scrollingEnabled: Bool

    @State var isExpanded: Bool = false
    @State private var nameTextSize: CGSize = .zero

    var body: some View {
        GeometryReader { pageSize in
            // Width of expanded modal
            let MODAL_WIDTH = pageSize.size.width - OFFSET_X * 2
            // Inner Width of expanded modal (including the padding)
            let MODAL_WIDTH_INNER = MODAL_WIDTH - PADDING * 2

            ZStack(alignment: isExpanded ? .center : .bottomLeading) {
                UnsplashAsyncImage(photo: photo, size: pageSize.size)

                VStack(alignment: .leading, spacing: 5) {
                    Text(photo.user.name)
                        .font(.system(size: 18, weight: .semibold))
                        .lineLimit(1)
                        .frame(maxWidth: MODAL_WIDTH_INNER, alignment: .leading)
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
                        }

                    // MARK: Content that will appear on expanded view
                    ModalContentView(photo: photo)
                        .frame(
                            width: MODAL_WIDTH_INNER,
                            alignment: .leading
                        )
                        .fixedSize()
                        .opacity(isExpanded ? 1 : 0)

                    Spacer()

                    PhotoStatisticsView(photo: photo)
                        .frame(
                            width: MODAL_WIDTH_INNER
                        )
                        .fixedSize()
                        .opacity(isExpanded ? 1 : 0)

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
                .simultaneousGesture(
                    TapGesture().onEnded(handleModalToggle))
            }.frame(
                width: pageSize.size.width, height: pageSize.size.height
            )
        }
    }

    func handleModalToggle() {
        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
        impactMed.impactOccurred()

        withAnimation(
            .spring(duration: animationSpeed, bounce: 0.25)
        ) {
            isExpanded.toggle()
            scrollingEnabled = !isExpanded
        }
    }
}

struct UnsplashAsyncImage: View {
    let photo: Photo

    let size: CGSize

    var body: some View {
        AsyncImage(url: URL(string: photo.urls.regular)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(
                    width: size.width,
                    height: size.height
                )
                .clipped()
        } placeholder: {
            AsyncImage(url: URL(string: photo.urls.thumb)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: size.width,
                        height: size.height
                    )
                    .blur(radius: 150)
                    .clipped()
            } placeholder: {
                Color.black
            }
        }

    }
}

struct ModalContentView: View {

    var photo: Photo

    var body: some View {
        Group {
            // Bio
            Text(photo.user.bio ?? "No Bio")
                .font(.system(size: 14, weight: .medium))
                .opacity(photo.user.bio == nil ? 0.75 : 1)
                .lineLimit(5)

            Text(photo.createdAt.dateFromString())
                .font(.caption)

            // Socials
            if photo.user.instagramUsername != nil
                || photo.user.twitterUsername != nil
            {
                Text("Socials")
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                    .padding(.top)
            }

            if let instagram = photo.user.instagramUsername {
                Text("Instagram: @\(instagram)")
                    .font(.system(size: 14, weight: .medium))
            }

            if let twitter = photo.user.twitterUsername {
                Text("Twitter: @\(twitter)")
                    .font(.system(size: 14, weight: .medium))
            }

            // Map
            if let location = photo.location,
                location.position.latitude != 0,
                location.position.longitude != 0
            {
                Text("Location")
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                    .padding(.top)

                PhotoMapLocation(photo: photo)
                    .frame(height: 150)
            }
        }
    }
}

struct PhotoMapLocation: View {

    private let coordinate: CLLocationCoordinate2D

    init(photo: Photo) {
        coordinate = CLLocationCoordinate2D(
            latitude: photo.location?.position.latitude ?? 0,
            longitude: photo.location?.position.longitude ?? 0
        )
    }

    var body: some View {
        Map(
            bounds: MapCameraBounds(
                centerCoordinateBounds: MKMapRect(
                    origin: MKMapPoint(coordinate),
                    size: MKMapSize(width: 1, height: 1)
                ),
                minimumDistance: 10000
            )
        ) {
            Marker("Photo Location", coordinate: coordinate)
                .tint(.red)
        }
        .cornerRadius(16)
        .mapControlVisibility(.hidden)
    }

}

struct PhotoStatisticsView: View {
    var photo: Photo

    var body: some View {
        HStack(spacing: 20) {
            HStack(spacing: 5) {
                Image(systemName: "heart.fill")
                Text("\(photo.likes)")
            }
            if let downloads = photo.downloads {
                HStack(spacing: 5) {
                    Image(systemName: "square.and.arrow.down.fill")
                    Text("\(downloads)")
                }
            }
        }
        .font(.system(size: 16, weight: .medium))
    }
}
