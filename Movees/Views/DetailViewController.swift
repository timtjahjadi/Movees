//
//  DetailViewController.swift
//  Movees
//
//  Created by Timotius Tjahjadi  on 05/06/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var backdrop_img: UIImageView!
    @IBOutlet weak var poster_img: UIImageView!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var rating_lbl: UILabel!
    @IBOutlet weak var overview_lbl: UILabel!
    
    @IBAction func fav_btn(_ sender: Any) {
        var movies = Set(arr.map { $0 })
        
        if movies.contains(data.id) {
            movies.remove(data.id)
            UserDefaults.standard.set(Array(movies), forKey: "Favorites")
            print("remove")
            fav_view.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            movies.insert(data.id)
            UserDefaults.standard.set(Array(movies), forKey: "Favorites")
            print("added")
            fav_view.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    @IBOutlet weak var fav_view: UIButton!
    
    var data: Movie = Movie(id: 0, title: "", backdrop_path: "", poster_path: "", overview: "", vote_average: 0, vote_count: 0, release_date: "")
    
    var data_img_backdrop: UIImage = UIImage(named: "asd")!
    
    var data_img_poster: UIImage = UIImage(named: "asd")!
    
    let arr = UserDefaults.standard.array(forKey: "Favorites")  as? [Int] ?? [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkFavorite()
        
        self.title = data.title
        
        backdrop_img.image = data_img_backdrop
        poster_img.image = data_img_poster
        
        date_lbl.text = data.release_date
        rating_lbl.text = String("\(data.vote_average) (\(data.vote_count))")
        overview_lbl.text = data.overview
    }

    func checkFavorite() {
        let movies = Set(arr.map { $0 })
        
        if movies.contains(data.id) {
            fav_view.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            fav_view.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}
