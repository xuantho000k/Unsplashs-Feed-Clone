//
//  GalleryViewController.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 16/11/2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
    static let storyboardId = "GalleryViewController"

    @IBOutlet weak var tableView: UITableView!
    
    private var controller: GalleryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
    }
    
    deinit {
        debugPrint("deinit - GalleryViewController")
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func reloadRow(_ index: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func tappedAtLogoutButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setUp() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(GalleryTableViewCell.nib, forCellReuseIdentifier: GalleryTableViewCell.key)
        
        let api = APIConnection(baseURL: Constants.apiUrl)
        let service = PhotoService(api)
        controller = GalleryController(viewController: self, service: service)
        controller?.getPhotos()
    }
}

extension GalleryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let controller = controller else { return 0 }
        
        return controller.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GalleryTableViewCell.key) as! GalleryTableViewCell
        cell.delegate = self
        
        let item = controller!.photos[indexPath.row]
        cell.loadData(item)
        
        return cell
    }
}

extension GalleryViewController: GalleryTableViewCellDelegate {
    func didTappAtLikeButton(onCell cell: GalleryTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        controller?.likePhoto(at: indexPath.row)
    }
}

extension GalleryViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (offsetY > 0 && offsetY > maximumOffset) {
            controller?.getPhotos()
        }
    }
}
