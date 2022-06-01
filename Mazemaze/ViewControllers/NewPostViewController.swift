//
//  NewPostViewController.swift
//  Mazemaze
//
//  Created by Owner on 2022/05/29.
//

import UIKit

class NewPostViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var selectedImage: UIImage? = nil
    let post = Post()
    let notification = NotificationCenter.default
    var currentTextFieldFrame: CGRect?
    var scrollOffset: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        post.senderId = UserManager.shared.id ?? AuthManager.userId()
        
        self.navigationController?.presentationController?.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SupportingTextTableViewCell", bundle: nil), forCellReuseIdentifier: "SupportingTextTableViewCell")
        tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        tableView.register(UINib(nibName: "TextButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "TextButtonTableViewCell")
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        tableView.register(UINib(nibName: "SpacerTableViewCell", bundle: nil), forCellReuseIdentifier: "SpacerTableViewCell")
        tableView.register(UINib(nibName: "SubmitButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "SubmitButtonTableViewCell")
        setupNavBar()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notification.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notification.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func hasEdited() -> Bool {
        if let _ = selectedImage {
            return true
        }
        if (post.title ?? "").removeBlanks() != "" {
            return true
        }
        for tag in post.relatedTags {
            if tag.removeBlanks() != "" {
                return true
            }
        }
        return false
    }
    
    func isFormFilled() -> Bool {
        guard let _ = selectedImage else { return false }
        if (post.title ?? "").removeBlanks() == "" {
            return false
        }
        if post.relatedTags.isEmpty {
            return false
        }
        for tag in post.relatedTags {
            if tag.removeBlanks() == "" {
                return false
            }
        }
        return true
    }
    
    @objc func onCancelButton() {
        closeModal()
    }
    
    func closeModal() {
        if hasEdited() {
            cancelAlert()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

//Select photo
extension NewPostViewController: TextButtonCellDelegate {
    
    func onTextButton(cell: TextButtonTableViewCell) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
}

//ImagePickerController
extension NewPostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return picker.dismiss(animated: true)
        }
        selectedImage = image
        tableView.reloadData()
        picker.dismiss(animated: true)
    }
    
}

//TextField
extension NewPostViewController: TextFieldCellDelegate {
    
    func textFieldDidBeginEditing(cell: TextFieldTableViewCell) {
        guard let path = tableView.indexPathForRow(at: cell.convert(cell.bounds.origin, to: tableView)) else { return }
        let cellFrame = tableView.cellForRow(at: path)!.frame
        let frame = CGRect(x: cellFrame.origin.x + 16, y: cellFrame.origin.y + 8, width: cellFrame.width - 32, height: cellFrame.height - 16)
        currentTextFieldFrame = frame
    }
    
    func textFieldDidEndEditing(text: String?, cell: TextFieldTableViewCell) {
        currentTextFieldFrame = nil
        
        guard let cellType = cell.cellType else { return }
        switch cellType {
        case .titleTextField:
            post.title = (text ?? "").removeBlanks()
        case .relatedTagTextField:
            guard let text = text else { break }
            if let index = cell.relatedTagIndex {
                post.relatedTags[index] = text
            } else {
                post.relatedTags.append(text)
            }
            post.relatedTags = post.relatedTags.filter{ $0.removeBlanks() != "" }
        }
        tableView.reloadData()
    }
    
}

//Submit
extension NewPostViewController: SubmitButtonCellDelegate {
    
    func onSubmitButton(cell: SubmitButtonTableViewCell) {
        if !isFormFilled() { return }
        cell.setIsLoading(text: "送信中")
        post.date = Date()
        
        Task {
            await createPost(userId: post.senderId ?? "")
        }
    }
    
    func createPost(userId: String) async {
        do {
            async let docId = PostCRUD.createPost(post: post)
            if let docId = try await docId {
                await uploadImage(userId: userId, docId: docId)
            }
        } catch {
            print(error)
        }
    }
    
    func uploadImage(userId: String, docId: String) async {
        do {
            guard let image = selectedImage else { return }
            async let imageUrl = ImageCRUD.uploadImage(userId: userId, docId: docId, image: image)
            if let imageUrl = try await imageUrl {
                await updatePost(docId: docId, key: "imageUrl", value: imageUrl)
            }
        } catch {
            print(error)
        }
    }
    
    func updatePost(docId: String, key: String, value: Any) async {
        do {
            async let docId = PostCRUD.updatePost(docId: docId, key: key, value: value)
            if let docId = try await docId {
                await addCreatedPostId(userId: post.senderId ?? "", docId: docId)
            }
        } catch {
            print(error)
        }
    }
    
    func addCreatedPostId(userId: String, docId: String) async {
        do {
            async let result = PostCRUD.addCreatedPostId(userId: userId, postId: docId)
            if let _ = try await result {
                self.dismiss(animated: true)
            }
        } catch {
            print(error)
        }
    }
    
}

//TableView
extension NewPostViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells(indexPath: nil).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells(indexPath: indexPath)[indexPath.row]
    }
    
    func cells(indexPath: IndexPath?) -> [UITableViewCell] {
        let indexPath = indexPath ?? IndexPath(row: 0, section: 0)
        var cells: [UITableViewCell] = []
        cells.append(contentsOf: [
            supportingTextCell(text: "画集の表紙", indexPath: indexPath),
            imageCell(image: selectedImage, indexPath: indexPath),
            textButtonCell(text: "画像を選択", indexPath: indexPath),
            spacerCell(indexPath: indexPath),
            supportingTextCell(text: "タイトル", indexPath: indexPath),
            textFieldCell(text: post.title ?? "", placeholder: "タイトルを入力", cellType: .titleTextField, relatedTagIndex: nil, indexPath: indexPath),
            spacerCell(indexPath: indexPath),
            supportingTextCell(text: "関連するワード", indexPath: indexPath)
        ])
        for (index, tag) in post.relatedTags.enumerated() {
            cells.append(textFieldCell(text: tag, placeholder: "関連するワードを入力", cellType: .relatedTagTextField, relatedTagIndex: index, indexPath: indexPath))
        }
        cells.append(contentsOf: [
            textFieldCell(text: "", placeholder: "関連するワードを入力", cellType: .relatedTagTextField, relatedTagIndex: nil, indexPath: indexPath),
            spacerCell(indexPath: indexPath),
            submitButtonCell(text: "投稿する", indexPath: indexPath),
            spacerCell(indexPath: indexPath),
            spacerCell(indexPath: indexPath),
            spacerCell(indexPath: indexPath),
            spacerCell(indexPath: indexPath),
            spacerCell(indexPath: indexPath)
        ])
        
        return cells
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func supportingTextCell(text: String, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportingTextTableViewCell", for: indexPath) as! SupportingTextTableViewCell
        cell.setCell(text: text)
        return cell
    }
    
    func imageCell(image: UIImage?, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
        cell.setCell(image: image)
        return cell
    }
    
    func textButtonCell(text: String, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextButtonTableViewCell", for: indexPath) as! TextButtonTableViewCell
        cell.delegate = self as TextButtonCellDelegate
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
    
    func spacerCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpacerTableViewCell", for: indexPath) as! SpacerTableViewCell
//        cell.setCell(height: height)
        return cell
    }
    
}

//Keyboard
extension NewPostViewController {
    
    @objc private func keyboardWillAppear(_ notification: Notification) {
        guard let frame = currentTextFieldFrame else { return }
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY: CGFloat = frame.maxY - keyboardFrame.minY + 120
        if offsetY > 0 {
            updateScrollViewSize(scrollSize: offsetY)
        }
    }
    
    @objc private func keyboardWillDisappear(_ notification: Notification) {
        restoreScrollViewSize()
    }
    
    func restoreScrollViewSize() {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func updateScrollViewSize(scrollSize: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: scrollSize, right: 0)
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
            self.tableView.contentOffset = CGPoint(x: 0, y: scrollSize)
        }
    }
    
}

//PresentationController
extension NewPostViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        closeModal()
    }
    
    func cancelAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "内容を破棄", style: .destructive) { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "入力を続ける", style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad{
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        present(alert, animated: true)
    }
    
}

//UI
extension NewPostViewController {
    
    func setupNavBar() {
        self.navigationItem.title = "新規投稿"
        let backButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(onCancelButton))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupViews() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
}
