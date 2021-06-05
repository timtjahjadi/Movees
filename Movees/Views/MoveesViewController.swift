//
//  ViewController.swift
//  Movees
//
//  Created by Timotius Tjahjadi  on 04/06/21.
//

import UIKit
import Combine

class MoveesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DataCollectionProtocol {
    
    @IBOutlet weak var UpComeCV: UICollectionView!
    @IBOutlet weak var PopCV: UICollectionView!
    
    var upComeViewModel: MovieViewModel!
    var popViewModel: MovieViewModel!
    
    var upComeMovie: [Movie] = []
    var popMovie: [Movie] = []
    
    private let webService = APIManager()
    private var upComeSubscriber: AnyCancellable?
    private var popSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewModel()
        fetchData()
        observeViewModel()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        UpComeCV.collectionViewLayout = layout
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal

        PopCV.collectionViewLayout = layout2
        
        PopCV.register(PopCollectionViewCell.nib(), forCellWithReuseIdentifier: PopCollectionViewCell.identifier)
        
        PopCV.delegate = self
        PopCV.dataSource = self
        
        UpComeCV.register(UpComeCollectionViewCell.nib(), forCellWithReuseIdentifier: UpComeCollectionViewCell.identifier)
        
        UpComeCV.delegate = self
        UpComeCV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UpComeCV.reloadData()
        PopCV.reloadData()
    }
    
    private func setViewModel() {
        upComeViewModel = MovieViewModel(webService: webService, endpoint: .upcoming)
        popViewModel = MovieViewModel(webService: webService, endpoint: .popular)
    }
    
    private func fetchData() {
        upComeViewModel.fetchMovie()
        popViewModel.fetchMovie()
    }
    
    private func observeViewModel() {
        upComeSubscriber = upComeViewModel.moviesSubject.sink(receiveCompletion: { resultCompletion in
            switch resultCompletion {
            case .failure(let error):
                print(error.localizedDescription)
            default: break
            }
        }) { (movies) in
            DispatchQueue.main.async {
                self.upComeMovie = movies.results
                self.UpComeCV.reloadData()
            }
        }
        
        popSubscriber = popViewModel.moviesSubject.sink(receiveCompletion: { resultCompletion in
            switch resultCompletion {
            case .failure(let error):
                print(error.localizedDescription)
            default: break
            }
        }) { (movies) in
            DispatchQueue.main.async {
                self.popMovie = movies.results
                self.PopCV.reloadData()
            }
        }
    }
    
    func passData(index: Int?) {
        let arr = UserDefaults.standard.array(forKey: "Favorites")  as? [Int] ?? [Int]()
        var movies = Set(arr.map { $0 })
        
        if movies.contains(index ?? 0) {
            movies.remove(index ?? 0)
            UserDefaults.standard.set(Array(movies), forKey: "Favorites")
            print("remove")
        } else {
            movies.insert(index ?? 0)
            UserDefaults.standard.set(Array(movies), forKey: "Favorites")
            print("added")
        }
        UpComeCV.reloadData()
        PopCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        
        if collectionView == PopCV {
            let backdrop_imagePath = popMovie[indexPath.item].backdrop_path ?? ""
            let poster_imagePath = popMovie[indexPath.item].poster_path ?? ""
            var backdrop_img = ""
            var poster_img = ""
            
            if backdrop_imagePath != "" {
                backdrop_img = "https://image.tmdb.org/t/p/w500" + backdrop_imagePath
            }
            if poster_imagePath != "" {
                poster_img = "https://image.tmdb.org/t/p/w500" + poster_imagePath
            }
            
            let backdrop_image = ImageLoader.init(urlString: backdrop_img).image ?? UIImage(named: "asd")!
            let poster_image = ImageLoader.init(urlString: poster_img).image ?? UIImage(named: "asd")!
            
            vc?.data_img_backdrop = backdrop_image
            vc?.data_img_poster = poster_image
            vc?.data = popMovie[indexPath.item]
        } else {
            let backdrop_imagePath = upComeMovie[indexPath.item].backdrop_path ?? ""
            let poster_imagePath = upComeMovie[indexPath.item].poster_path ?? ""
            var backdrop_img = ""
            var poster_img = ""
            
            if backdrop_imagePath != "" {
                backdrop_img = "https://image.tmdb.org/t/p/w500" + backdrop_imagePath
            }
            if poster_imagePath != "" {
                poster_img = "https://image.tmdb.org/t/p/w500" + poster_imagePath
            }
            
            let backdrop_image = ImageLoader.init(urlString: backdrop_img).image ?? UIImage(named: "asd")!
            let poster_image = ImageLoader.init(urlString: poster_img).image ?? UIImage(named: "asd")!
            
            vc?.data_img_backdrop = backdrop_image
            vc?.data_img_poster = poster_image
            vc?.data = upComeMovie[indexPath.item]
        }
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == PopCV {
            return popMovie.count
        } else {
            return upComeMovie.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == PopCV {
            return CGSize(width: 300, height: 200)
        }
        return CGSize(width: 300, height: 400)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let arr = UserDefaults.standard.array(forKey: "Favorites")  as? [Int] ?? [Int]()
        let movies = Set(arr.map { $0 })
        
        if collectionView == PopCV {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: PopCollectionViewCell.identifier, for: indexPath) as! PopCollectionViewCell
            
            let movie = popMovie[indexPath.item]
            let imagePath = popMovie[indexPath.item].backdrop_path ?? ""
            var img = ""
            
            if imagePath != "" {
                img = "https://image.tmdb.org/t/p/w500" + imagePath
            }
            
            let image = ImageLoader.init(urlString: img).image ?? UIImage(named: "asd")!

            cell2.configure(with: String(movie.title), image: image)
            
            cell2.index = popMovie[indexPath.item].id
            cell2.delegate = self
            
            
            if movies.contains(popMovie[indexPath.item].id) {
                cell2.changeStar(with: true)
            } else {
                cell2.changeStar(with: false)
            }
            
            return cell2
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpComeCollectionViewCell.identifier, for: indexPath) as! UpComeCollectionViewCell
            
            let movie2 = upComeMovie[indexPath.item]
            let imagePath2 = upComeMovie[indexPath.item].poster_path ?? ""
            var img2 = ""
            
            if imagePath2 != "" {
                img2 = "https://image.tmdb.org/t/p/w500" + imagePath2
            }
            
            let image2 = ImageLoader.init(urlString: img2).image
            cell.configure(with: String(movie2.title), image: image2 ?? UIImage(named: "asd")!)
            
            cell.index = upComeMovie[indexPath.item].id
            cell.delegate = self
            
            
            if movies.contains(upComeMovie[indexPath.item].id) {
                cell.changeStar(with: true)
            } else {
                cell.changeStar(with: false)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

