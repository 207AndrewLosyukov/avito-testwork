//
//  DetailsViewController.swift
//  avito
//
//  Created by Андрей Лосюков on 24.08.2023.
//

import UIKit

/* У этого экрана 6 состояний:
 загрузка экрана в целом
 загруженный экран, но без картинки
 загрузка картинки
 загруженный экран вместе с картинкой
 состояние ошибки, когда экран не загрузился совсем
 состояние ошибки, когда не загрузилась картинка (ставится placeholder).
 Информация подгружается в том числе и из кэша, так как URLRequest настроен с такой cachePolicy
 */

class DetailsViewController: UIViewController {

    enum Constants {
        static let bigFontSize = 25.0
        static let middleFontSize = 22.0
        static let smallFontSize = 18.0

        static let buttonHeight = 50.0
        static let defaultInset = 20.0
        static let animationDuration = 0.4

        static let descriptionTitleLabelText = "Описание"
        static let geoTitleLabelText = "Расположение"
        static let contactsTitleLabelText = "Контакты"
        static let buyButtonText = "Купить"
        
        static let stackViewSpacing = 10.0
        static let stackViewCustomSpacing = 2.0

        static let errorImageViewTopConstraint = 125.0
        static let errorImageViewSideConstraint = 40.0
        static let errorImageViewHeight = 400.0
        static let errorLabelTopConstraint = 20.0
    }

    private let output: DetailsViewOutputProtocol

    private let scrollView = UIScrollView()

    private var isButtonAnimating = false

    private let screenWidth = UIScreen.main.bounds.width

    private let refreshControl = UIRefreshControl()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.isHidden = true
        return contentView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var imageActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
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
        label.font = UIFont.systemFont(ofSize: Constants.smallFontSize)
        label.numberOfLines = 0
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: Constants.bigFontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.boldSystemFont(ofSize: Constants.bigFontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var geoLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: Constants.smallFontSize)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: Constants.smallFontSize)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: Constants.smallFontSize)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: Constants.smallFontSize)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: Constants.smallFontSize)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.middleFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    private lazy var geoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.middleFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    private var buyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setTitle(Constants.buyButtonText, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constants.middleFontSize)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var contactsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.middleFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    init(output: DetailsViewOutputProtocol) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .white
        output.loadDetails()
        setupUI()
    }

    private func setupUI() {
        view.addSubview(activityIndicator)
        scrollView.isUserInteractionEnabled = false
        buyButton.addTarget(self, action: #selector(buyButtonOnTapHandler), for: .touchUpInside)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onPressedButton(_:)))
        buyButton.addGestureRecognizer(longPressRecognizer)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        refreshControl.addTarget(self, action: #selector(refreshDetails), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        scrollView.addSubview(errorImageView)
        scrollView.addSubview(errorLabel)
        imageView.addSubview(imageActivityIndicator)
        setupLoadingStateConstraints()
        setupErrorStateConstraints()
        setupLoadedStateConstraints()
    }

    private func setupLoadedStateConstraints() {
        let stackView = UIStackView(arrangedSubviews: [
            priceLabel, titleLabel, buyButton, geoTitleLabel, geoLabel, descriptionTitleLabel, descriptionLabel, createdDateLabel, contactsTitleLabel, emailLabel, phoneNumberLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        stackView.spacing = Constants.stackViewSpacing
        stackView.setCustomSpacing(Constants.stackViewCustomSpacing, after: geoTitleLabel)
        stackView.setCustomSpacing(Constants.stackViewCustomSpacing, after: descriptionTitleLabel)
        stackView.setCustomSpacing(Constants.stackViewCustomSpacing, after: contactsTitleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true

        contentView.addSubview(imageView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: screenWidth),
            imageView.widthAnchor.constraint(equalToConstant: screenWidth)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.defaultInset),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.defaultInset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.defaultInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.defaultInset),
        ])

        NSLayoutConstraint.activate([
            buyButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            buyButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            buyButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }

    private func setupErrorStateConstraints() {
        NSLayoutConstraint.activate([
            errorImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.errorImageViewTopConstraint),
            errorImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.errorImageViewSideConstraint),
            errorImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.errorImageViewSideConstraint),
            errorImageView.heightAnchor.constraint(equalToConstant: Constants.errorImageViewHeight)
        ])
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: Constants.errorLabelTopConstraint),
            errorLabel.leadingAnchor.constraint(equalTo: errorImageView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: errorImageView.trailingAnchor),
        ])
    }

    private func setupLoadingStateConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            imageActivityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            imageActivityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }

    @objc func onPressedButton(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            if !isButtonAnimating {
                isButtonAnimating = true
                animateButton(with: Constants.animationDuration)
            } else {
                isButtonAnimating = false
                if let presentationLayer = buyButton.layer.presentation() {
                    buyButton.layer.transform = presentationLayer.transform
                    buyButton.layer.removeAnimation(forKey: "shake")
                }
                UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
                    self?.buyButton.transform = .identity
                }, completion: { [weak self] _ in
                    self?.buyButton.layer.removeAllAnimations()
                })
            }
        }
    }

    private func animateButton(with duration: Double) {
        let translationAnimation = CABasicAnimation(keyPath: "position")

        let yPosition = buyButton.frame.maxY - buyButton.frame.height / 2.0
        translationAnimation.autoreverses = true
        translationAnimation.fromValue = CGPoint(x: view.frame.width / 2.0 - 5, y: yPosition - 5)
        translationAnimation.toValue = CGPoint(x: view.frame.width / 2.0, y: yPosition)
        translationAnimation.duration = duration / 2
        translationAnimation.repeatCount = .infinity

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.autoreverses = true
        rotationAnimation.fromValue = -.pi / 30.0
        rotationAnimation.toValue = .pi / 30.0
        rotationAnimation.duration = duration / 2
        rotationAnimation.repeatCount = .infinity

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [rotationAnimation, translationAnimation]
        animationGroup.autoreverses = true
        animationGroup.duration = duration
        animationGroup.repeatCount = .infinity
        buyButton.layer.add(animationGroup, forKey: "shake")
    }

    @objc func refreshDetails() {
        imageView.image = nil
        refreshControl.beginRefreshing()
        output.loadDetails()
    }

    @objc func buyButtonOnTapHandler() {
    }
}

extension DetailsViewController: DetailsViewInputProtocol {
    func setLoadedWithoutImageState(detailsModel: ItemDetailsResponse) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }

        scrollView.isUserInteractionEnabled = true
        errorImageView.isHidden = true
        errorLabel.isHidden = true
        contentView.isHidden = false

        descriptionTitleLabel.text = Constants.descriptionTitleLabelText
        geoTitleLabel.text = Constants.geoTitleLabelText
        contactsTitleLabel.text = Constants.contactsTitleLabelText

        titleLabel.text = detailsModel.title
        priceLabel.text = detailsModel.price
        geoLabel.text = "\(detailsModel.location), \(detailsModel.address)"
        createdDateLabel.text = detailsModel.createdDate
        descriptionLabel.text = detailsModel.description
        emailLabel.text = detailsModel.email
        phoneNumberLabel.text = detailsModel.phoneNumber
    }

    func setLoadedWithImageState(data: Data?) {
        imageActivityIndicator.stopAnimating()
        if let data = data {
            imageView.image = UIImage(data: data)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }

    func setLoadingWithoutImageState() {
        activityIndicator.startAnimating()
    }

    func setLoadingWithImageState() {
        imageActivityIndicator.startAnimating()
    }

    func setErrorState(error: String) {
        scrollView.isUserInteractionEnabled = true
        contentView.isHidden = true
        errorImageView.isHidden = false
        errorLabel.isHidden = false
        activityIndicator.stopAnimating()
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        errorLabel.text = "Потяните экран вниз для перезагрузки. Ошибка: \(error)"
    }
}
