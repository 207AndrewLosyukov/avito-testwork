//
//  MainViewController.swift
//  avito
//
//  Created by Андрей Лосюков on 24.08.2023.
//

import UIKit

enum ProductSection: Hashable {
    case none
}

struct ProductItem: Hashable {
    static func == (lhs: ProductItem, rhs: ProductItem) -> Bool {
        lhs.id == rhs.id && lhs.model == rhs.model
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    let id: UUID = UUID()
    var model: ProductCellModel
}

class MainViewController: UIViewController {

    private var output: MainViewOutputProtocol
    private let refreshControl = UIRefreshControl()

    enum Constants {
        static let spacing = 20.0
    }

    init(output: MainViewOutputProtocol) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var dataSource = makeDataSource()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        refreshControl.addTarget(self, action: #selector(loadItemsList), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.register(ProductCell.self,
            forCellWithReuseIdentifier: "ProductCell")
        collectionView.dataSource = dataSource
        setupConstraints()
        loadItemsList()
    }

    private func setupConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func loadItemsList() {
        output.loadItemsList()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 230)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.spacing, left: Constants.spacing, bottom: 0, right: Constants.spacing)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let transition = CATransition()
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        output.openDetails(navigationController: navigationController, withItemIndex: indexPath.item)
    }
}

extension MainViewController: MainViewInputProtocol {

    func setLoading(enabled: Bool) {
        if enabled {
            refreshControl.beginRefreshing()
        } else {
            refreshControl.endRefreshing()
        }
    }

    func updateSnapshot(with items: [ProductItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<ProductSection, ProductItem>()
        snapshot.appendSections([ProductSection.none])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<ProductSection, ProductItem> {
        let dataSource = UICollectionViewDiffableDataSource<ProductSection, ProductItem>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, item) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
                return UICollectionViewCell()
            }
            self?.output.configure(cell: cell, index: indexPath.item)
            return cell
        })
        return dataSource
    }
}
