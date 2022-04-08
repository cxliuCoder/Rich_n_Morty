//
//  RMCharacterTableViewCell.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-07.
//

import UIKit

class RMCharacterTableViewCell: UITableViewCell {
    let photoView = UIImageView()
    let nameLable = UILabel()
    let episodeCountLabel = UILabel()
    
    // layout views
    let cardView = UIView()
    let hStackView = UIStackView()
    let vStackView = UIStackView()
    
    // model
    var characterModel: CharacterModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.isSelected = false
        characterModel = nil
        photoView.image = nil
    }
    
    // setup cell during init/register
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        /// |---------------------–---------|
        /// |  |  |-------|     xxxxxx    |  |     -|
        /// |  |  |         |     xxxxxx   |  |      |
        /// |  |  |         |     xxxxxx   |  |    150
        /// |  |  |-------|                    |  |       |
        /// |  |---------------------------|  |     -|
        ///
        
        // card view
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: Constants.contentViewHPadding).isActive = true
        cardView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Constants.contentViewVPadding).isActive = true
        cardView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -Constants.contentViewHPadding).isActive = true
        cardView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.contentViewVPadding).isActive = true
        
        // add border
        cardView.layer.borderColor = Constants.borderColor
        cardView.layer.borderWidth = Constants.borderWidth
        cardView.layer.cornerRadius = Constants.cornerRadius

        // HStack
        cardView.addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: Constants.spacing).isActive = true
        hStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.spacing).isActive = true
        hStackView.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -Constants.spacing).isActive = true
        hStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Constants.spacing).isActive = true
        
        hStackView.distribution = .fill
        hStackView.axis = .horizontal
        hStackView.spacing = Constants.spacing
        hStackView.alignment = .center
        
        // photo
        hStackView.addArrangedSubview(photoView)
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.widthAnchor.constraint(equalToConstant: Constants.imageWidthConstrant).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: Constants.imageHeightConstrant).isActive = true

        // lables VStack
        hStackView.addArrangedSubview(vStackView)
        vStackView.distribution = .equalSpacing
        vStackView.axis = .vertical
        vStackView.spacing = Constants.spacing
        vStackView.alignment = .leading

        // info labels
        vStackView.addArrangedSubview(nameLable)
        vStackView.addArrangedSubview(episodeCountLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // apply model to the cell
    func apply(with model: CharacterModel) {
        if let url = URL(string: model.image) {
            photoView.loadImage(from: url, placeHolderImage: Constants.cellPlaceHolderImage)
        }
        nameLable.text = model.name
        episodeCountLabel.text = episodeLabelText(model.episode.count)
    }
    
    private func episodeLabelText(_ count: Int) -> String {
        if count == 1 {
            return "Appeared in 1 episode"
        } else {
            return "Appeared in \(count) episodes"
        }
    }
}

extension RMCharacterTableViewCell {
    struct Constants {
        static let contentViewVPadding: CGFloat = 4
        static let contentViewHPadding: CGFloat = 8
        static let spacing: CGFloat = 8
        
        static let borderColor = UIColor.lightGray.cgColor
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 20
        
        static let imageHeightConstrant: CGFloat = 100
        static let imageWidthConstrant: CGFloat = 100
            
        static let defaultCellIdentifier = "defaultCell"
        
        static let cellPlaceHolderImage = UIImage(systemName: "person.crop.circle")
    }
}
