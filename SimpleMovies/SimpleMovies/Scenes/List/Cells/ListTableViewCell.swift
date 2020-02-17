//
//  ListTableViewCell.swift
//  SimpleMovies
//
//  Created by Eduardo Sanches Bocato on 16/02/20.
//  Copyright © 2020 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

protocol ListItemData {
    var title: String { get }
    var year: String { get }
    var poster: String { get }
}

extension SearchResponse.Result: ListItemData {}

class ListTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var imageLoadTask: URLSessionDataTask?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        movieDescriptionLabel.text = nil
        imageLoadTask?.cancel()
    }
    
    // MARK: - Setup

    func setup(_ data: ListItemData) {
        setupImageView(with: data.poster)
        setupDescriptionLabel(with: data)
    }
    
    private func setupImageView(with poster: String) {
        posterImageView.contentMode = .scaleAspectFit
        imageLoadTask = posterImageView.setImageFromURL(poster)
    }
    
    private func setupDescriptionLabel(with data: ListItemData) {
        
        let descriptionAttributedText = NSMutableAttributedString(
            string: data.title,
            attributes: [.font: UIFont.systemFont(ofSize: 14)]
        )
        
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]
        
        descriptionAttributedText.append(.init(string: " (", attributes: boldAttributes))
        descriptionAttributedText.append(.init(string: data.year, attributes: boldAttributes))
        descriptionAttributedText.append(.init(string: ")", attributes: boldAttributes))
        
        movieDescriptionLabel.attributedText = descriptionAttributedText
        
    }
    
}
