//
//  ProfileViewController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 04/07/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    var profilVM = ProfileVM()
    var imagePicker: UIImagePickerController!
    var profileImage: UIImage?
    var userInfo: LoginModel?
    var isEditingOn: Bool = false
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilVM.registerCell(self.table)
        if let loggedInData = Utils.getUserInfo() {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginModel.self, from: loggedInData) {
                userInfo = loadedPerson
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
extension ProfileViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let headerView = UIView()
            headerView.backgroundColor = .black
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width, height: 20))
            label.textColor = UIColor(red: 160.0/255.0, green: 44.0/255.0, blue: 17.0/255.0, alpha: 1)
            label.font = UIFont.boldSystemFont(ofSize: 16)
            headerView.addSubview(label)
            if section == 1 {
                label.text = "Profile Information".capitalized
            } else {
                label.text = "Subscribed Events".capitalized
            }
            
            return headerView
        }
         return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.profilVM.heightForRowInSection(indexPath.section))
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.profilVM.tableSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profilVM.rows(section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.profilVM.cellForRow(indexPath.section,indexPath.row,tableView) as! ProfilePicCell
            
            if let image = self.profileImage {
                cell.profileImg.image = image
                cell.profilePic.setBackgroundImage(nil, for: .normal)
                cell.profileImg.contentMode = .scaleToFill
                cell.profileImg.layer.cornerRadius = cell.profileImg.frame.size.width/2
            }
            
            cell.delegate = self
            return cell
        } else {
            let cell = self.profilVM.cellForRow(indexPath.section,indexPath.row,tableView) as! FormCell
            if indexPath.section == self.numberOfSections(in: tableView) - 1 {
                cell.textField.isHidden = true
                cell.topLabel.isHidden = true
            }
            cell.topLabel.text = self.profilVM.profileTitleForRow(indexPath.row)
            cell.textField.placeholder = "  \(self.profilVM.profileTitleForRow(indexPath.row))"
            cell.textField.text = "  \(self.profilVM.textForIndex(indexPath.row, self.userInfo))"
            cell.textField.delegate = self
            return cell
        }
    }
}
extension ProfileViewController: ProfilePicCellDelwgate, UIImagePickerControllerDelegate {
    func capturePicture() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.profileImage = info[.originalImage] as? UIImage
        self.navigationItem.setHidesBackButton(false, animated: true);
        DispatchQueue.main.async {
            self.table.reloadData()
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isEditingOn
    }
}
