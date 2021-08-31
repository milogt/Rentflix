//
//  FilterViewController.swift
//  Rentflix
//
//  Created by Guo Tian on 2/20/21.
//

import UIKit

class FilterViewController: UIViewController {
    
    weak var delegate: FilterDelegate?
    
    @IBOutlet weak var ratingFilter: UISegmentedControl!
    @IBOutlet weak var priceFilter: UIStepper!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var initindex = 4
    private var initprice = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ratingFilter.addTarget(self, action: #selector(updateFilter), for: .valueChanged)
        priceFilter.addTarget(self, action: #selector(updateFilter), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.integer(forKey: "StepperValue") != 0 {
            initindex = UserDefaults.standard.integer(forKey: "SegmentIndex")
            initprice = Double(UserDefaults.standard.integer(forKey: "StepperValue"))
        }
        ratingFilter.selectedSegmentIndex = initindex
        priceFilter.value = initprice
        priceLabel.text = "Less than: $" + String(priceFilter.value)
    }
    
    @objc func updateFilter() {
        let idx = ratingFilter.selectedSegmentIndex
        let value = priceFilter.value
        priceLabel.text = "Less than: $" + String(priceFilter.value)
        UserDefaults.standard.setValue(idx,forKey: "SegmentIndex")
        UserDefaults.standard.setValue(value,forKey: "StepperValue")
        delegate?.applyNew(newRate: ratingFilter.titleForSegment(at: idx)!, newPrice: String(value))
    }
    
//    @objc func updatePrice() {
//        let value = priceFilter.value
//        priceLabel.text = "Less than: $" + String(priceFilter.value)
//        UserDefaults.standard.setValue(value,forKey: "StepperValue")
//        delegate?.applyPrice(condition: String(value))
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
