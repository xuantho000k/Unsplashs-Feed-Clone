//
//  ImageCache.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 17/11/2021.
//

import Foundation
import UIKit

final class ImageCache {
    typealias Completion = (UIImage) -> Void
    
    static let shared = ImageCache()
    
    private init() {
        debugPrint("init Image cache")
    }
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    func load(url: NSURL, completion: @escaping Completion) {
        DispatchQueue.global().async {
            self.excute(url: url, completion: completion)
        }
    }
    
    private func excute(url: NSURL, completion: @escaping Completion) {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        URLSession.shared.dataTask(with: url as URL) { data, response, error in
            guard let responseData = data, let image = UIImage(data: responseData) else {
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
            self.cachedImages.setObject(image, forKey: url)
        }.resume()
    }
    
    private func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
}
