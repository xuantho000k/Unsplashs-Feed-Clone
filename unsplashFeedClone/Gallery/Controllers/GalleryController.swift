//
//  GalleryController.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 17/11/2021.
//

import Foundation

class GalleryController {
    
    private var service: PhotoService?
    private weak var viewController: GalleryViewController?
    private var isLoading = false
    private var currentPage = 0
    var photos: [Photo] = []
    
    init(viewController: GalleryViewController, service: PhotoService) {
        self.viewController = viewController
        self.service = service
    }
    
    func getPhotos() {
        if !isLoading {
            isLoading = true
            service?.getListPhotos(page: currentPage + 1, completion: { photos, error in
                self.isLoading = false
                if let error = error {
                    debugPrint(error)
                } else {
                    self.currentPage += 1
                    self.reload(photos)
                }
            })
        }
    }
    
    func likePhoto(at index: Int) {
        let photo = photos[index]
        debugPrint(photo.id)
//        service?.likePhoto(photo.id, completion: { isSuccess, error in
//            if let error = error {
//                debugPrint(error)
//            } else {
//                self.viewController?.reloadRow(index)
//            }
//        })
    }
    
    private func reload(_ photos: [Photo]?) {
        if let photos = photos, !photos.isEmpty {
            self.photos.append(contentsOf: photos)
            self.viewController?.reloadData()
        }
    }
    
    deinit {
        debugPrint("deinit - GalleryController")
    }
}
