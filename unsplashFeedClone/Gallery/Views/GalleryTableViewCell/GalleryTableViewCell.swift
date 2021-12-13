//
//  GalleryTableViewCell.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 16/11/2021.
//

import UIKit

protocol GalleryTableViewCellDelegate: AnyObject {
    func didTappAtBackButton(onCell cell: GalleryTableViewCell)
}

class GalleryTableViewCell: UITableViewCell {
    
    static let key = "GalleryTableViewCell"
    static var nib: UINib {
        return UINib(nibName: Self.key, bundle: nil)
    }

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblNumberLike: UILabel!
    
    weak var delegate: GalleryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnLike.setTitle("Like", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(_ photo: Photo) {
        lblUserName.text = photo.user.name
        lblNumberLike.text = String(photo.likes)
        guard let imageUrl = NSURL(string: photo.urls.thumb) else {
            return
        }
        ImageCache.shared.load(url: imageUrl) { image in
            self.imgView.image = image
        }
    }
    
    @IBAction func tappedAtLikeButton(_ sender: Any) {
        delegate?.didTappAtBackButton(onCell: self)
    }
    
}
