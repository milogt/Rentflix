//
//  DetailViewController.swift
//  Rentflix
//
//  Created by Guo Tian on 2/18/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var detailRating: UILabel!
    @IBOutlet weak var detailText: UITextView!

    
    var titlename: String = ""
    var rate: String = ""
    var pricing: String = ""
    var desp: String = ""
    var previewUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTitle.text = titlename
        detailPrice.text = pricing
        detailRating.text = rate
        detailText.text = desp
        // bar button setup refer to:
        // https://stackoverflow.com/questions/30022780/uibarbuttonitem-in-navigation-bar-programmatically
        let preview = UIBarButtonItem(title: "Preview", style: .done, target: self, action: #selector(didTap))
        self.navigationItem.rightBarButtonItem  = preview

        // Do any additional setup after loading the view.
    }
    
    func config(with movie:Movies){
        titlename = movie.trackName!
        pricing = String(movie.trackPrice ?? 0)
        rate = movie.contentAdvisoryRating!
        desp = movie.longDescription!
        previewUrl = movie.previewUrl ?? "unknown"
    }
    
    @objc func didTap() {
        UIApplication.shared.open(NSURL(string: previewUrl)! as URL)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
