//
//  LiveEventsViewController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 20/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit
import SDWebImage

class LiveEventsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var model = LiveEventsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "ListTableCell", bundle: Bundle.main), forCellReuseIdentifier: "liveCell")
        self.model.getLiveEvents { (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showActionAlert("Error", error.localizedDescription) {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
extension LiveEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.liveEvents?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liveCell") as! ListTableCell
        let liveEvnt = self.model.liveEvents?[indexPath.row]
        let imageLoader = ImageCacheLoader()
        if let urlString = liveEvnt?.thumbnail.small {
            imageLoader.fetchImage(imagePath: urlString) { (image) in
                cell.thumnail.image = image
            }
        }
        cell.priceContainer.isHidden = true
        if let priceInfo = liveEvnt?.price.first {
            if Int(priceInfo.amount) ?? 0 > 0 {
                cell.priceContainer.isHidden = false
                cell.price.text = "\(priceInfo.currency)\(priceInfo.amount)"
            }
        }
        cell.eventType.text = liveEvnt?.mediaType.rawValue
        cell.thumnail.image = UIImage(named: "load")
        cell.eventInfoLbl.attributedText = NSAttributedString(string: "\(liveEvnt?.des ?? "")\n\(liveEvnt?.publishDate ?? "")")
        return cell
    }
    
    func getSymbolForCurrencyCode(code: String) -> String {
        var candidates: [String] = []
        let locales: [String] = NSLocale.availableLocaleIdentifiers
        for localeID in locales {
            guard let symbol = findMatchingSymbol(localeID: localeID, currencyCode: code) else {
                continue
            }
            if symbol.count == 1 {
                return symbol
            }
            candidates.append(symbol)
        }
        let sorted = sortAscByLength(list: candidates)
        if sorted.count < 1 {
            return ""
        }
        return sorted[0]
    }
    func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
        let locale = Locale(identifier: localeID as String)
        guard let code = locale.currencyCode else {
            return nil
        }
        if code != currencyCode {
            return nil
        }
        guard let symbol = locale.currencySymbol else {
            return nil
        }
        return symbol
    }

    func sortAscByLength(list: [String]) -> [String] {
        return list.sorted(by: { $0.count < $1.count })
    }
}
