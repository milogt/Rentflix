//
//  MoviesCollectionViewController.swift
//  Rentflix
//
//  Created by Guo Tian on 2/18/21.
//

import UIKit

//private let reuseIdentifier = "Cell"

class MoviesCollectionViewController: UICollectionViewController {

    fileprivate let url = "https://itunes.apple.com/search?media=movie&limit=200&term=love"
    typealias DataSource = UICollectionViewDiffableDataSource<Int,Movies>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Int,Movies>
    
    var datasource: DataSource!
    var snapshot = DataSourceSnapshot()
    
    var Movie = [Movies]()
    var filterMovies = [Movies]()
    
    @IBOutlet var moviecollectionview: UICollectionView!
    @IBOutlet weak var filterBar: UIBarButtonItem!
//    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        moviecollectionview.collectionViewLayout = createLayout()
        moviecollectionview.delegate = self
        moviecollectionview.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        moviecollectionview.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        moviecollectionview.dataSource = self
        configureCollectionViewDataSource()
        fetchItems()
//        localload()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        moviecollectionview.collectionViewLayout = createLayout()
    }
    
    // popover controller setup refer to:
    // https://slicode.com/how-to-show-popovers-in-ios-swift/
    @IBAction func showPopover(_ sender: Any) {
        let popoverContentController = storyboard?.instantiateViewController(withIdentifier: "Popover") as? FilterViewController
        popoverContentController?.delegate = self
        popoverContentController?.modalPresentationStyle = .popover
        popoverContentController?.preferredContentSize = CGSize(width: 300, height: 200)
         
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.barButtonItem = filterBar
            popoverPresentationController.delegate = self
            if let popoverController = popoverContentController {
                present(popoverController, animated: true, completion: nil)
            }
        }
    }

    func configureCollectionViewDataSource() {
        datasource = DataSource(collectionView: moviecollectionview, cellProvider: { (collectionView, indexPath, movie) -> MovieViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! MovieViewCell
//            print(movie.trackName)
            cell.configure(with:movie)
            return cell
        })
    }
    // data fetch setup refer to:
    // https://www.youtube.com/watch?v=SBeizUTImoQ&t=263s
    func fetchItems() {
        
        guard let movieurl = URL(string: url) else { return }
        let request = URLRequest(url: movieurl)
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let fetchedItems = try JSONDecoder().decode(Results.self, from: data)
                        self.Movie = fetchedItems.results
                        self.filterMovies = self.Movie
                        self.applySnapshot(movies: self.Movie)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } else {
                print("HTTPURLResponse code: \(response.statusCode)")
            }
        }.resume()
        
    }
    
    func localload(){
        if let path = Bundle.main.path(forResource: "1", ofType: "txt") {
          do {
              let fileUrl = URL(fileURLWithPath: path)
              // Getting data from JSON file using the file URL
              let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
              let fetchedItems = try JSONDecoder().decode(Results.self, from: data)
              Movie = fetchedItems.results
              filterMovies = Movie
              self.applySnapshot(movies: Movie)
          } catch {
              print("wrong")
          }
      }
    }

    func applySnapshot(movies: [Movies]){
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([0])
        print(movies.count)
        snapshot.appendItems(movies)
        datasource.apply(snapshot, animatingDifferences:true)
        
    }
    
    // segue setup refer to:
    // https://www.codingexplorer.com/segue-uitableviewcell-taps-swift/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "detail",
            let destination = segue.destination as? DetailViewController,
            let Index = moviecollectionview.indexPathsForSelectedItems?[0]
        {
            destination.config(with: filterMovies[Index.row])
        }
    }
    
    // UICollectionViewCompositionalLayout refer to:
    // https://lickability.com/blog/getting-started-with-uicollectionviewcompositionallayout/
    func createLayout() -> UICollectionViewLayout {
        var item:CGFloat = 2
        if UIDevice.current.orientation.isLandscape {
            if UIScreen.main.bounds.height < 390 || UIScreen.main.bounds.width < 390{
                item = 3
            } else {
                item = 4
            }
        }

        let compositionalLayout: UICollectionViewCompositionalLayout = {
        let fraction: CGFloat = 1 / item
        let inset: CGFloat = 10
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        return UICollectionViewCompositionalLayout(section: section)
        }()
        return compositionalLayout
    }
  

}
//extension MoviesCollectionViewController : UICollectionViewDelegateFlowLayout {
//
//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    let paddingSpace = sectionInsets.left * (2 + 1)
//    let availableWidth = view.frame.width - paddingSpace
//    let widthPerItem = availableWidth / 2
//
//    return CGSize(width: widthPerItem, height: widthPerItem)
//  }
//
//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      insetForSectionAt section: Int) -> UIEdgeInsets {
//    return sectionInsets
//  }
//
//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//    return sectionInsets.left
//  }
//}

extension MoviesCollectionViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
        }
     
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
     
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
    return true
    }
}

// filter array with string value refer to:
// https://stackoverflow.com/questions/40804458/how-to-filter-an-array-of-structs-with-value-of-other-array-in-swift
extension MoviesCollectionViewController:FilterDelegate {
    func applyNew(newRate: String, newPrice: String) {
        if newRate == "ALL"{
            filterMovies = Movie
        }
        else{
            filterMovies = Movie.filter { $0.contentAdvisoryRating == newRate }
        }
        filterMovies = filterMovies.filter { Float($0.trackPrice ?? 0) <= Float(newPrice)! }
        applySnapshot(movies: filterMovies)
    }
    
//    func applyPrice(newRate: String, newPrice: String) {
//        filterMovies = Movie.filter { Float($0.trackPrice) <= Float(condition)! }
//        applySnapshot(movies: filterMovies)
//    }
}
