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
        hasher.combine(model)
    }

    let id: UUID = UUID()
    var model: ProductCellModel
}

/* У этого экрана 3 состояния:
 состояние ошибки
 состояние загрузки
 загруженный экран (картинки могут не догрузиться - на их месте будет placeholder)
 Информация подгружается в том числе и из кэша, так как URLRequest настроен с такой cachePolicy
 */

class MainViewController: UIViewController {

    private var output: MainViewOutputProtocol
    private let refreshControl = UIRefreshControl()
    let searchController = UISearchController()
    
    enum Constants {
        static let spacing = 20.0
        static let minimumLineSpacing = 15.0

        static let cellWidth = 160.0
        static let cellHeight = 230.0

        static let transitionAnimationDuration = 0.6

        static let fontSize = 18.0

        static let errorImageViewTopConstraint = 80.0
        static let errorImageViewSideConstraint = 40.0
        static let errorImageViewHeight = 400.0
        static let errorLabelTopConstraint = 20.0
    }

    init(output: MainViewOutputProtocol) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var dataSource = makeDataSource()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        let collectionView = UICollectionView(frame: .zero,  collectionViewLayout: layout)
        collectionView.isUserInteractionEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "error"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: Constants.fontSize)
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadItemsList()
    }

    private func setupUI() {
        view.backgroundColor = .white
        refreshControl.addTarget(self, action: #selector(loadItemsList), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.Constants.reuseIdentifier)
        collectionView.dataSource = dataSource
    }

    private func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.addSubview(errorImageView)
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorImageView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: Constants.errorImageViewTopConstraint),
            errorImageView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: Constants.errorImageViewSideConstraint),
            errorImageView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -Constants.errorImageViewSideConstraint),
            errorImageView.heightAnchor.constraint(equalToConstant: Constants.errorImageViewHeight)
        ])
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: Constants.errorLabelTopConstraint),
            errorLabel.leadingAnchor.constraint(equalTo: errorImageView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: errorImageView.trailingAnchor),
        ])
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<ProductSection, ProductItem> {
        let dataSource = UICollectionViewDiffableDataSource<ProductSection, ProductItem>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, item) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.Constants.reuseIdentifier, for: indexPath) as? ProductCell else {
                return UICollectionViewCell()
            }
            self?.output.configure(cell: cell, index: indexPath.item)
            return cell
        })
        return dataSource
    }


    @objc private func loadItemsList() {
        output.loadItemsList()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.cellWidth, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.spacing, left: Constants.spacing, bottom: 0, right: Constants.spacing)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let transition = CATransition()
        transition.duration = Constants.transitionAnimationDuration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        output.openDetails(navigationController: navigationController, withItemIndex: indexPath.item)
    }
}

extension MainViewController: MainViewInputProtocol {

    func setErrorState(error: String) {
        collectionView.isUserInteractionEnabled = true
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
        errorImageView.isHidden = false
        errorLabel.isHidden = false
        errorLabel.text = "Потяните экран вниз для перезагрузки. Ошибка: \(error)"
    }

    func setLoadingState() {
        activityIndicator.startAnimating()
    }

    func setLoadedState(with items: [ProductItem]) {
        collectionView.isUserInteractionEnabled = true
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        errorImageView.isHidden = true
        errorLabel.isHidden = true

        updateLoadedState(with: items)
    }

    func updateLoadedState(with items: [ProductItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<ProductSection, ProductItem>()
        snapshot.appendSections([ProductSection.none])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
