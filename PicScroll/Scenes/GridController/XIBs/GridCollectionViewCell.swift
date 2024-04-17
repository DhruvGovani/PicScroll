//
//  GridCollectionViewCell.swift
//  PicScroll
//
//  Created by Dhruv Govani on 16/04/24.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imgThumbnail: UIImageView!
    @IBOutlet private weak var imgFailed: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgFailed.isHidden = true
        imgThumbnail.clipsToBounds = true
        imgThumbnail.layer.borderWidth = 0.3
        imgThumbnail.layer.borderColor = UIColor.lightGray.cgColor
        imgThumbnail.contentMode = .scaleAspectFill
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgFailed.isHidden = true
        imgThumbnail.image = nil
    }
    
    /// Set thumb image
    func setImage(_ thumb : Thumbnail?){
        guard let thumb = thumb else{
            imgFailed.isHidden = false
            return
        }
        
        if let url = thumb.downloadURL{
            imgThumbnail.loadImage(from: url, placeholder: UIImage(named: "news-placeholder")) { status in
                DispatchQueue.main.async {
                    self.imgFailed.isHidden = status
                }
            }
        }else{
            imgThumbnail = nil
            imgFailed.isHidden = false
        }
    }

}
