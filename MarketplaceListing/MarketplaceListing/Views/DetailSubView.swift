//
//  DetailSubView.swift
//  MarketplaceListing
//
//  Created by Hamza on 19/12/2024.
//

import UIKit

class DetailSubView: UIView {
    let titreLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()

    let sousTitreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(titre: String, sousTitre: String) {
        titreLabel.text = titre
        sousTitreLabel.text = sousTitre
        titreLabel.sizeToFit()
        sousTitreLabel.sizeToFit()
        backgroundColor = .red
    }

    private func setupLayout() {
        addSubview(titreLabel)
        addSubview(sousTitreLabel)

        titreLabel.translatesAutoresizingMaskIntoConstraints = false
        sousTitreLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            sousTitreLabel.topAnchor.constraint(equalTo: titreLabel.bottomAnchor, constant: 8),
            sousTitreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sousTitreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sousTitreLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }

    func suggestedHeight() -> CGFloat {
        let titleLabelSize = titreLabel.frame
        let sousTitreLabelViewSize = sousTitreLabel.frame
        let totalHeight = titleLabelSize.height + sousTitreLabelViewSize.height + 16 + 8
        return totalHeight
    }
}
