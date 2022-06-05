//
//  ProfileSettingViewController.swift
//  Mazemaze
//
//  Created by Owner on 2022/06/05.
//

import UIKit

class ProfileSettingViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var userName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userId = UserManager.shared.id ?? AuthManager.userId() {
            if let name = UserManager.shared.name {
                userName = name
                tableView.reloadData()
            } else {
                //Get user
                Task {
                    await getUser(userId: userId)
                }
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SupportingTextTableViewCell", bundle: nil), forCellReuseIdentifier: "SupportingTextTableViewCell")
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        tableView.register(UINib(nibName: "SubmitButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "SubmitButtonTableViewCell")
        setupNavBar()
        setupViews()
    }
    
    func getUser(userId: String) async {
        do {
            async let user = UserCRUD.getUser(uid: userId)
            if let user = try await user {
                UserManager.shared.setUser(id: user.id, name: user.name, blockUserIds: user.blockUserIds)
                userName = user.name
                tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
    @objc func onDoneButton() {
        self.dismiss(animated: true)
    }
    
    func isFormFilled() -> Bool {
        userName = userName.removeBlanks()
        if userName == "" {
            return false
        }
        if userName == UserManager.shared.name {
            return false
        }
        return true
    }

}

//TextField
extension ProfileSettingViewController: TextFieldCellDelegate {
    
    func textFieldDidBeginEditing(cell: TextFieldTableViewCell) {
        //Scroll if needed
    }
    
    func textFieldDidEndEditing(text: String?, cell: TextFieldTableViewCell) {
        userName = text?.removeBlanks() ?? ""
        tableView.reloadData()
    }
    
}

//Submit
extension ProfileSettingViewController: SubmitButtonCellDelegate {
    
    func onSubmitButton(cell: SubmitButtonTableViewCell) {
        let userId = UserManager.shared.id ?? AuthManager.userId() ?? ""
        Task {
            await updateUserName(userId: userId, name: userName)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateUserName(userId: String, name: String) async {
        do {
            async let userId = UserCRUD.updateUser(userId: userId, key: "name", value: name)
            if let userId = try await userId {
                UserManager.shared.setUserName(name: userName)
            }
        } catch {
            print(error)
        }
    }
    
}

extension ProfileSettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = [
            supportingTextCell(text: "アカウントの表示名", indexPath: indexPath),
            textFieldCell(text: userName, placeholder: "アカウントの表示名を入力", cellType: .titleTextField, relatedTagIndex: nil, indexPath: indexPath),
            submitButtonCell(text: "保存する", indexPath: indexPath)
        ]
        
        return cells[indexPath.row]
    }
    
    
    func supportingTextCell(text: String, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportingTextTableViewCell", for: indexPath) as! SupportingTextTableViewCell
        cell.setCell(text: text)
        return cell
    }
    
    func textFieldCell(text: String, placeholder: String, cellType: CellType, relatedTagIndex: Int?, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
        cell.delegate = self as TextFieldCellDelegate
        cell.setCell(text: text, placeholder: placeholder, cellType: cellType, relatedTagIndex: relatedTagIndex)
        return cell
    }
    
    func submitButtonCell(text: String, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitButtonTableViewCell", for: indexPath) as! SubmitButtonTableViewCell
        cell.delegate = self as SubmitButtonCellDelegate
        cell.setCell(text: text, isButtonEnabled: isFormFilled())
        return cell
    }
    
}

extension ProfileSettingViewController {
    
    func setupNavBar() {
        self.navigationItem.title = "プロフィール"
        let doneButton = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(onDoneButton))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func setupViews() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
}
