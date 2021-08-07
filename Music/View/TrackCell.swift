//
//  TrackCell.swift
//  Music
//
//  Created by Артем Соловьев on 22.07.2021.
//

import UIKit

class TrackCell: UITableViewCell {
    
    // UI
    @IBOutlet weak var trackNumber: UILabel!
    @IBOutlet weak var trackName: UILabel!
    
    // Method
    func updateCell (track: Track) {
        trackNumber.text = String(track.trackNumber)
        trackName.text = track.trackName
    }
    
}
