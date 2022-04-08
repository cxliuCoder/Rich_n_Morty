//
//  RMDetailViewController.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-07.
//

import UIKit

class RMDetailViewController: UIViewController {
    var characterModel: CharacterModel!
    
    let scrollView = UIScrollView()
    
    let photoView = UIImageView()
    let nameLabel = UILabel()
    let statusLabel = UILabel()
    let speciesLabel = UILabel()
    let genderLabel = UILabel()
    let locationLabel = UILabel()
    
    init(with model: CharacterModel) {
        self.characterModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNaviBar()
        setupUI()
        
        apply(with: self.characterModel)
    }
    
    /// Navigation bar items with action menu
    func setNaviBar() {
        // Set title
        navigationItem.title = characterModel.name
        
        // Set cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.viewBackgroundColor
        
        scrollView.contentSize = view.bounds.size
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.stackViewHPadding).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.stackViewVPadding).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Constants.stackViewHPadding).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.stackViewVPadding).isActive = true
        
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        stackView.alignment = .leading
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        // setting imageView
        stackView.addArrangedSubview(photoView)
        
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -Constants.stackViewHPadding * 2).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: Constants.imageHeightConstrant).isActive = true
        
        
        // adding labels
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(speciesLabel)
        stackView.addArrangedSubview(genderLabel)
        stackView.addArrangedSubview(locationLabel)
        
        // adding an empty view to absorb the space
        let paddingView = UIView()
        paddingView.backgroundColor = Constants.viewBackgroundColor
        stackView.addArrangedSubview(paddingView)
    }
    
    private func apply(with model: CharacterModel) {
        // if image not valid, just show placeholder
        if let url = URL(string: model.image) {
            photoView.loadImage(from: url, placeHolderImage: Constants.cellPlaceHolderImage)
        } else {
            photoView.image = Constants.cellPlaceHolderImage
        }
        
        // setup labels
        nameLabel.text = "Name:  \(model.name)"
        statusLabel.text = "Status:  \(model.status)"
        speciesLabel.text = "Species:  \(model.species)"
        genderLabel.text = "Gender:  \(model.gender)"
        locationLabel.text = "Current location:  \(model.currentLocation.name)"
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RMDetailViewController {
    struct Constants {
        static let stackViewVPadding: CGFloat = 8
        static let stackViewHPadding: CGFloat = 8
        static let spacing: CGFloat = 8
        
        static let imageHeightConstrant: CGFloat = 400
        
        static let viewBackgroundColor = UIColor.white
        static let cellPlaceHolderImage = UIImage(systemName: "person.crop.circle")
    }
}
