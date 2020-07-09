//
//  LiveEventsViewController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 20/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

class LiveEventsViewController: BaseViewController,SideMenuDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var selectedMenu: SideMenuOptions?
    var model = LiveEventsVM()
    var sideMenuController: SideMenuViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showForceSubscribeAlert), name: Notification.Name(kForceSubscription), object: nil)
        
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
    
    //Are you sure want to logout
    @objc func showForceSubscribeAlert(_ notification: NSNotification) {
        let channelData = notification.userInfo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showConfirmationAlert("Message", "You are not subscribed to watch \(channelData?["channelName"] ?? ""). Please visit www.playgoodmusic.com/ to subscribe") { (status) in
                if status {
                    if let url = URL(string: "https://www.playgoodmusic.com") {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func menuAction() {
        print("menu from home")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.sideMenuController = storyboard.instantiateViewController(withIdentifier: "sideMenu") as? SideMenuViewController
        sideMenuController?.delegate = self
        let window = UIApplication.shared.windows.first!
        if let sideMenuView = sideMenuController?.view {
            window.addSubview(sideMenuView);
        }
        
     
    }
    private func removeSideMenu() {
        let window = UIApplication.shared.windows.first!
        for view in window.subviews {
            if view == self.sideMenuController?.view {
                view.removeFromSuperview()
            }
        }
    }
    func dismissSideMenu() {
        self.removeSideMenu()
    }
    func navigateToScreen(screenName: SideMenuOptions?) {
        self.removeSideMenu()
        self.selectedMenu = screenName
        switch screenName {
        case .account:
            self.performSegue(withIdentifier: "toProfile", sender: self)
        case.privacy,.terms:
            self.performSegue(withIdentifier: "toWeb", sender: self)
        case .signin:
            self.performSegue(withIdentifier: "toLogin", sender: self)
        case .signout:
            self.showConfirmationAlert("Confirm", "Are you sure want to logout?") { (status) in
                if status {
                    Utils.updateUserStatus(false)
                    self.navigateToLogin()
                }
            }
            
        default:
            break
        }
    }

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
        cell.eventInfoLbl.attributedText = NSAttributedString(string: "\(liveEvnt?.des ?? "")\n\(Utils.getDate(dateString: liveEvnt?.publishDate ?? "") ?? "")")
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

extension LiveEventsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerData = self.model.liveEvents?[indexPath.row]
        self.model.updateCurrentSelectedEvent(liveEvent: playerData, withIndex: indexPath.row)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toPlayer", sender: nil)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeb" {
            var url: String?
            let webController = segue.destination as? CommonController
            switch self.selectedMenu {
            case .privacy:
                url = RequestBuilder.EndPoint.privacyPolicy.path
            case .terms:
                url = RequestBuilder.EndPoint.terms.path
            default:
                break
            }
            webController?.title = self.selectedMenu?.rawValue
            webController?.urlString = url
        } else if segue.identifier == "toProfile" {
            //
        } else {
            let playerView = segue.destination as? PlayerViewController
            playerView?.urlString = self.model.getSelectedEvent().event?.url
            playerView?.selectedIndex = self.model.getSelectedEvent().selectedIndex
            playerView?.videoList = self.model.liveEvents
        }
        
    }
}
