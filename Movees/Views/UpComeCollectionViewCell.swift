//
//  UpComeCollectionViewCell.swift
//  Movees
//
//  Created by Timotius Tjahjadi  on 05/06/21.
//

import UIKit

protocol DataCollectionProtocol {
    func passData(index: Int?)
}

class UpComeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var Img_MoviePoster: UIImageView!
    @IBOutlet weak var Lbl_MovieTitle: UILabel!
    @IBAction func fav_btn(_ sender: Any) {
        delegate?.passData(index: index)
    }
    @IBOutlet weak var fav_view: UIButton!
    
    var delegate: DataCollectionProtocol?
    var index: Int?
    
    static let identifier = "UpComeCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with title: String, image: UIImage) {
        Lbl_MovieTitle.text = title
        Img_MoviePoster.image = image
    }
    
    public func changeStar(with isAdded: Bool) {
        if isAdded {
            fav_view.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            fav_view.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "UpComeCollectionViewCell", bundle: nil)
    }

}
