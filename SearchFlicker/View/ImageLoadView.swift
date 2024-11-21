//
//  ImageLoadView.swift
//  SearchFlicker
//
//

import SwiftUI

struct ImageLoadView: View {
    @State private var image: Image? = nil
    let url: URL

    var body: some View {
        if let image = image {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
        } else {
            ProgressView()
                .frame(width: 100, height: 100)
                .onAppear {
                    loadImage()
                }
        }
    }

    private func loadImage() {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                }
            } catch {
                print("Failed to load image: \(error)")
            }
        }
    }
}
