//
//  SideMenuViewController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 22/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

enum SideMenuOptions: String {
    case account = "MY ACCOUNT"
    case contact = "CONTACT US"
    case terms = "TERMS OF USE"
    case privacy = "PRIVACY POLICY"
    case signout = "SIGN OUT"
    case signin = "SIGN IN"
}
let kSignInTitle = "SIGN IN"
protocol SideMenuDelegate: class {
    func dismissSideMenu()
    func navigateToScreen(screenName: SideMenuOptions?)
}
class SideMenuViewController: UIViewController {
    weak var delegate : SideMenuDelegate?
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private var sideMenuOptionsLoggedIn:[SideMenuOptions] = [SideMenuOptions.account,SideMenuOptions.contact,SideMenuOptions.terms,SideMenuOptions.privacy,SideMenuOptions.signout]
    
    private var sideMenuOptionsNotLoggedIn:[SideMenuOptions] = [SideMenuOptions.contact,SideMenuOptions.terms,SideMenuOptions.privacy,SideMenuOptions.signin]
    
    private var tableData:[SideMenuOptions]?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(gestureRecognizer:)))
        self.view.addGestureRecognizer(tapRecognizer)
        tapRecognizer.delegate = self
        
        self.tableView.register(UINib(nibName: "SideMenuOptionsCell", bundle: Bundle.main), forCellReuseIdentifier: "option")
        tableData = Utils.isUserLoggedIn() ? sideMenuOptionsLoggedIn : sideMenuOptionsNotLoggedIn
        
    }
    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
       self.delegate?.dismissSideMenu()
    }

}
extension SideMenuViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.tag == 100 {
            return false
        }
        return true
    }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option") as! SideMenuOptionsCell
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.text = tableData?[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.navigateToScreen(screenName: self.tableData?[indexPath.row])
    }
}
