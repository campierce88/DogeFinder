//
//  ViewController.swift
//  DogeFinder
//
//  Created by Cameron Pierce on 2/4/18.
//  Copyright © 2018 Cameron Pierce. All rights reserved.
//

import UIKit

class BreedsTableViewController: UIViewController {

    static let identifier = "BreedsTableViewController"

    static func instantiate() -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! BreedsTableViewController
        return viewController
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var retryButton: UIButton!

    var refreshControl: UIRefreshControl!
    var breeds = [Breed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Dogo Types"

        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)

        tableView.register(UINib(nibName: BreedTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BreedTableViewCell.identifier)

        loadBreeds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadBreeds() {
        BreedsAPI().getBreeds(completion: { (breeds) in
            self.updated(breeds)
        }, failure: { (response, error) in
            self.updated([])
            self.tableView.isHidden = true
            self.errorView.isHidden = false
        })
    }

    @objc func refreshTableView(_ sender: Any) {
        breeds = []
        loadBreeds()
    }

    @IBAction func retryPressed(_ sender: Any) {
        tableView.isHidden = false
        errorView.isHidden = true
        loadBreeds()
    }
}

extension BreedsTableViewController {

    func updated(_ breeds: [Breed]) {
        for breed in breeds {
            if !self.breeds.contains(where: { $0.id == breed.id }) {
                self.breeds.append(breed)
            }
        }
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}

extension BreedsTableViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: BreedTableViewCell.identifier, for: indexPath) as? BreedTableViewCell, indexPath.item < breeds.count {
            cell.setup(with: breeds[indexPath.item])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension BreedsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(BreedTableViewCell.cellHeight)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BreedTableViewCell, let breed = cell.breed else { return }
        navigationController?.pushViewController(BreedDetailsViewController.instantiate(with: breed), animated: true)
    }
}
