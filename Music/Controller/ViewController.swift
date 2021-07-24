//
//  ViewController.swift
//  Music
//
//  Created by Артем Соловьев on 13.07.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // UI
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var albums = [Album]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

// MARK: - CollectionView methods

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AlbumCell {
            cell.updateCell(album: albums[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: albumId) as! AlbumViewController
        vc.album = albums[indexPath.row]
        if let cell = collectionView.cellForItem(at: indexPath) as? AlbumCell {
            vc.image = cell.albumImage.image
        }
        self.present(vc, animated: true, completion: nil)
        searchBar.resignFirstResponder()
    }

}

// MARK: - SearchBar methods

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil || searchBar.text != "" {
            ItunesConnection.instance.getAlbums(searchRequest: searchBar.text!) { (requestedAlbums) in
                self.albums = requestedAlbums.sorted(by: {$0.collectionName < $1.collectionName})
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                if self.collectionView.visibleCells.count == 0 {
                    let alertController = UIAlertController(title: "Attention", message: "The search for artists did not give results, enter another artist", preferredStyle: .alert)
                    let okeyAction = UIAlertAction(title: "Okey", style: .default, handler: {
                        (action : UIAlertAction!) -> Void in })
                    alertController.addAction(okeyAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
        
        searchBar.resignFirstResponder()
    }
}
