//
//  AlbumCell.swift
//  Music
//
//  Created by Артем Соловьев on 22.07.2021.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    // UI
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    // Method
    func updateCell (album: Album) {
        let imageUrl = URL(string: album.artworkUrl100)
        
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: imageUrl!) {
                DispatchQueue.main.async {
                    self.albumImage.image = UIImage(data: imageData)
                }
            }
        }
        albumTitleLabel.text = album.collectionName
    }
    
}
