//
//  AlbumViewController.swift
//  Music
//
//  Created by Артем Соловьев on 22.07.2021.
//

import UIKit

class AlbumViewController: UIViewController {
    
    // UI
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // Dependencies
    var album: Album!
    var image: UIImage!
    var tracks = [Track]()
    var imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView =  UIView()

        updateLabels()
        loadTracks()
        updateImage()
    }
    
    // MARK: - Methods
    func updateLabels () {
        albumLabel.text = album.collectionName
        artistLabel.text = album.artistName
        styleLabel.text = album.primaryStyleName
        countryLabel.text = album.country
        yearLabel.text = album.releaseDate
    }
    
    func updateImage()  {
        let searchImage = album.artworkUrl100.replacingOccurrences(of: "100x100bb", with: "500x500bb")
        let imageUrl = URL(string: searchImage)!
        if let cachedImage = imageCache.object(forKey: imageUrl.absoluteString as NSString) {
            self.albumImage.image = cachedImage
        }else {
            DispatchQueue.global().async {
                self.imageCache.setObject(self.image, forKey: imageUrl.absoluteString as NSString)
                if let imageData = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.albumImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    func loadTracks() {
        ItunesConnection.instance.getAlbumTracks(collectionId: album.collectionId) { (requestedTracks) in
            self.tracks = requestedTracks
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

// MARK: - TableView methods

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: trackId, for: indexPath) as? TrackCell {
            cell.updateCell(track: tracks[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
}

