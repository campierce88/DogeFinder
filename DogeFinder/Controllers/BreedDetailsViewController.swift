//
//  BreedDetailsViewController.swift
//  DogeFinder
//
//  Created by Cameron Pierce on 2/4/18.
//  Copyright © 2018 Cameron Pierce. All rights reserved.
//

import UIKit

class BreedDetailsViewController: UIViewController {

    static let identifier = "BreedDetailsViewController"

    static func instantiate(with breed: Breed) -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! BreedDetailsViewController
        viewController.breed = breed
        return viewController
    }

    var breed: Breed!

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = breed.fullName

        collectionView.register(UINib(nibName: BreedImageCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BreedImageCollectionViewCell.identifier)

        loadBreedImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadBreedImages() {
        guard breed.imageUrls == nil else { return }

        BreedsAPI().getBreedImages(for: breed, completion: { (breed) in
            self.breed = breed
            self.collectionView.reloadData()
        }, failure: { (response, error) in
            // NOOP
        })
    }
}

extension BreedDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let viewMargin = BreedImageCollectionViewCell.viewMargin
        return UIEdgeInsets(top: viewMargin, left: viewMargin, bottom: viewMargin, right: viewMargin)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return BreedImageCollectionViewCell.cellPadding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return BreedImageCollectionViewCell.cellPadding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: BreedImageCollectionViewCell.cellWidthLandscape, height: BreedImageCollectionViewCell.cellHeightLandscape)
        } else {
            return CGSize(width: BreedImageCollectionViewCell.cellWidthPortrait, height: BreedImageCollectionViewCell.cellHeightPortrait)
        }
    }
}

extension BreedDetailsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breed.imageUrls?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let images = breed.imageUrls, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedImageCollectionViewCell.identifier, for: indexPath) as? BreedImageCollectionViewCell {
            cell.setup(with: images[indexPath.item])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension BreedDetailsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Coming Soon!", message: "Full screen image view of this cute dogo will be here before you know it!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
