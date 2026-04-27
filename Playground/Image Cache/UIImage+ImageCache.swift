import UIKit

extension UIImageView {

    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder

        // 1. Check memory cache first
        if let cached = ImageCache.shared.get(forKey: urlString) {
            self.image = cached
            return
        }

        guard let url = URL(string: urlString) else { return }

        // 2. Fetch from network
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self,
                  error == nil,
                  let data,
                  let image = UIImage(data: data) else { return }

            // 3. Store in cache
            ImageCache.shared.set(image, forKey: urlString)

            // 4. Update UI on main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}