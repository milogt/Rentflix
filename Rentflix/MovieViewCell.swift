//
//  CollectionViewCell.swift
//  Rentflix
//
//  Created by Guo Tian on 2/19/21.
//

import UIKit
//import Kingfisher

class MovieViewCell: UICollectionViewCell {
        
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var coverimage: UIImageView!
    

    func configure(with movie: Movies) {
        
        coverimage.image = UIImage(systemName: "rays")!
        let imageUrl = movie.artworkUrl100!
        if let url = URL(string: imageUrl) {
            load(url: url)
        }
        title.text = movie.trackName
        price.text = String(movie.trackPrice ?? 0)
        rating.text = movie.contentAdvisoryRating

        
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self!.coverimage.image = image
                    }
                }
            }
        }
    }
}
