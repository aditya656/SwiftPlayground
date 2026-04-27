//
//  ImageLoader.swift
//  Playground
//
//  Created by Aditya Patole on 19/04/26.
//

import Combine
import SwiftUI

@MainActor
final class ImageLoader: ObservableObject {

    @Published var image: UIImage? = nil
    @Published var isLoading = false

    private var currentTask: Task<Void, Never>?

    func load(from urlString: String) {
        // 1. Cache hit — instant return
        if let cached = ImageCache.shared.get(forKey: urlString) {
            self.image = cached
            return
        }

        guard let url = URL(string: urlString) else { return }

        isLoading = true

        // 2. Cancel any previous in-flight request
        currentTask?.cancel()

        currentTask = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                // Check if task was cancelled before doing more work
                guard !Task.isCancelled else { return }

                guard let downloaded = UIImage(data: data) else { return }

                // 3. Write to cache
                ImageCache.shared.set(downloaded, forKey: urlString)

                self.image = downloaded
                self.isLoading = false

            } catch {
                // URLError.cancelled is thrown on cancel — silently ignore
                isLoading = false
            }
        }
    }

    func cancel() {
        currentTask?.cancel()
        currentTask = nil
        isLoading = false
    }
}
