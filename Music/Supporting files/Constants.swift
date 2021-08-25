//
//  Constans.swift
//  Music
//
//  Created by Артем Соловьев on 22.07.2021.
//

import Foundation

enum Constans: String {
    case BASE_URL = "https://itunes.apple.com/search?entity=album&attribute=albumTerm&limit=100&term="
    case ALBUM_URL = "https://itunes.apple.com/lookup?entity=song&id="
    case cellId = "cell"
    case albumId = "AlbumViewController"
    case trackId = "TrackCell"
}
