//
//  BreedTableViewCell.swift
//  DogeFinder
//
//  Created by Cameron Pierce on 2/4/18.
//  Copyright © 2018 Cameron Pierce. All rights reserved.
//

import UIKit
import SDWebImage

class BreedTableViewCell: UITableViewCell {

    static let identifier = "BreedTableViewCell"
    static let cellHeight = 58.0

    override var reuseIdentifier: String? {
        get {
            return BreedTableViewCell.identifier
        }
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var breedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var breed: Breed!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        commonInit()
    }

    func commonInit() {
        selectionStyle = .none
        backgroundColor = .clear
        

        if containerView != nil {
            containerView.layer.masksToBounds = true
            containerView.layer.cornerRadius = 4.0
            containerView.layer.borderColor = UIColor.lightGray.cgColor
            containerView.layer.borderWidth = 1.0

            breedImageView.layer.masksToBounds = true
            breedImageView.layer.cornerRadius = 4.0
        }
    }

    override func prepareForReuse() {
        nameLabel.text = nil
        breedImageView.image = nil
    }

    func setup(with breed: Breed) {
        self.breed = breed

        nameLabel.text = breed.fullName?.capitalized
        updateImage()
        loadBreedImages()
    }

    func updateImage() {
        if let urlString = breed.imageUrls?.first, let url = URL(string: urlString) {
            breedImageView.sd_setImage(with: url, completed: nil)
        }
    }

    func loadBreedImages() {
        guard breed.imageUrls == nil else { return }
        
        BreedsAPI().getBreedImages(for: breed, completion: { (breed) in
            self.updateImage()
        }, failure: { (response, error) in
            // NOOP
        })
    }
}

