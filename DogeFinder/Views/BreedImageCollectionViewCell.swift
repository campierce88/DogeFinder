//
//  BreedImageCollectionViewCell.swift
//  DogeFinder
//
//  Created by Cameron Pierce on 2/4/18.
//  Copyright © 2018 Cameron Pierce. All rights reserved.
//

import UIKit
import SDWebImage

class BreedImageCollectionViewCell: UICollectionViewCell {

    static var safeAreaInsets: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
            } else {
                return UIEdgeInsets.zero
            }
        }
    }
    static let landscapeWidth = UIScreen.main.bounds.width - safeAreaInsets.left - safeAreaInsets.right

    static let viewMargin: CGFloat = 16
    static let cellPadding: CGFloat = 10
    static let cellWidthPortrait: CGFloat = (UIScreen.main.bounds.width - (cellPadding * 3) - (viewMargin * 2)) / 3
    static let cellHeightPortrait = cellWidthPortrait
    static let cellWidthLandscape: CGFloat = (landscapeWidth - (cellPadding * 3) - (viewMargin * 2)) / 3
    static let cellHeightLandscape = cellWidthLandscape
    static let identifier = "BreedImageCollectionViewCell"

    override var reuseIdentifier: String? {
        get {
            return BreedImageCollectionViewCell.identifier
        }
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    var imageUrl: String?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        commonInit()
    }

    func commonInit() {
        if containerView != nil {
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 4.0
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
    }

    func setup(with imageUrl: String? = nil) {
        self.imageUrl = imageUrl

        if let urlString = imageUrl, let url = URL(string: urlString) {
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
}
