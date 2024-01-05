//
//  CharacterListTableViewCell.swift
//  MarvelliciousVIP
//
//  Created by Mert Gürcan on 4.01.2024.
//


import Foundation
import UIKit

class CharacterListTableViewCell: UITableViewCell {

    var result: Result? {
        didSet {
            guard let result = result else { return }
            ImageDownloader.downloaded(from: result.finalPhoto) { image in
                self.characterImage.image = image
            }
            characterName.text = result.name
        }
    }

    var characterImage : UIImageView = {
        let iv = UIImageView()
        return iv
    }()

    var characterName : UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.numberOfLines = 0
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    func setupViews() {
        backgroundColor = .white
        addSubview(characterImage)
        characterImage.anchor(top: topAnchor, left: leftAnchor, bot: bottomAnchor, right: nil, topConstant: 10, leftConstant: 10, botConstant: 10, rightConstant: 0, width: 100, height: 0)

        addSubview(characterName)
        characterName.anchor(top: topAnchor, left: characterImage.rightAnchor, bot: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 30, botConstant: 0, rightConstant: 20, width: 0, height: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
