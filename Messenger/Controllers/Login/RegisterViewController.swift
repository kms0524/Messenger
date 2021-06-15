//
//  RegisterViewController.swift
//  Messenger
//
//  Created by 강민성 on 2021/05/18.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

final class RegisterViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "성", attributes: [.foregroundColor: UIColor.systemGray])
        field.leftView = UIView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: 5,
                          height: 0
            ))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "이름", attributes: [.foregroundColor: UIColor.systemGray])
        field.leftView = UIView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: 5,
                          height: 0
            ))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "이메일", attributes: [.foregroundColor: UIColor.systemGray])
        field.leftView = UIView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: 5,
                          height: 0
            ))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [.foregroundColor: UIColor.systemGray])
        field.leftView = UIView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: 5,
                          height: 0
            ))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "로그인"
        view.backgroundColor = .systemBackground
        
        
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesutre = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfile))
        imageView.addGestureRecognizer(gesutre)
        scrollView.addGestureRecognizer(gesutre)
    }
    
    @objc private func didTapChangeProfile() {
        presentPhotoActionSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(
            x: (scrollView.width - size) / 2,
            y: 20,
            width: size,
            height: size
        )
        imageView.layer.cornerRadius = imageView.width / 2.0
        firstNameField.frame = CGRect(
            x: 30,
            y: imageView.bottom + 10,
            width: scrollView.width - 60,
            height: 52
        )
        lastNameField.frame = CGRect(
            x: 30,
            y: firstNameField.bottom + 10,
            width: scrollView.width - 60,
            height: 52
        )
        emailField.frame = CGRect(
            x: 30,
            y: lastNameField.bottom + 10,
            width: scrollView.width - 60,
            height: 52
        )
        passwordField.frame = CGRect(
            x: 30,
            y: emailField.bottom + 10,
            width: scrollView.width - 60,
            height: 52
        )
        registerButton.frame = CGRect(
            x: 30,
            y: passwordField.bottom + 10,
            width: scrollView.width - 60,
            height: 52
        )
    }
    
    @objc private func registerButtonTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              !email.isEmpty,
              !password.isEmpty,
              !lastName.isEmpty,
              !firstName.isEmpty,
              password.count >= 6 else {
            alertUserLoginError()
            return
        }
        // Firebase Login
        
        DatabaseManager.shared.userExist(with: email) { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard !exists else {
                // 사용자가 이미 있음
                strongSelf.alertUserLoginError(message: "이미 같은 이메일로 가입된 사용자가 있습니다.")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(
                withEmail: email,
                password: password, completion: { authReslt, error in
                    guard authReslt != nil, error == nil else {
                        print("사용자 생성에 오류")
                        return
                    }
                    
                    UserDefaults.standard.setValue(email, forKey: "email")
                    UserDefaults.standard.setValue("\(firstName) \(lastName)", forKey: "name")
                    
                    let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                    DatabaseManager.shared.insetUser(with: chatUser, completion: { success in
                        if success {
                            // 이미지 업로드
                            guard let image = strongSelf.imageView.image,
                                  let data = image.pngData() else {
                                return
                            }
                            let fileName = chatUser.profilePictureFileName
                            StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                                switch result {
                                case .success(let downloadUrl):
                                    UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                    print(downloadUrl)
                                case .failure(let error):
                                    print("storage manager 에러: \(error)")
                                }
                            })
                        }
                    })
                    
                    strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                })
            
        }
    }
    
    func alertUserLoginError(message: String = "성, 이름, 이메일, 비밀번호를 모두 입력해주세요.") {
        let alert = UIAlertController(
            title: "이런!",
            message: message,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "확인",
                          style: .cancel,
                          handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "계정 생성"
        navigationController?.pushViewController(vc, animated: true)
    }
    

    

}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(
            title: "프로필 사진",
            message: "어떤 방식으로 프로필 사진을 설정하시겠습니까?",
            preferredStyle: .actionSheet)
        actionSheet.addAction(
            UIAlertAction(title: "취소",
                          style: .cancel,
                          handler: nil
        ))
        actionSheet.addAction(
            UIAlertAction(title: "사진 촬영하기",
                          style: .default,
                          handler: { [weak self] _ in
                            self?.presentCamera()
                          }))
        actionSheet.addAction(
            UIAlertAction(title: "앨범에서 가져오기",
                          style: .default,
                          handler: { [weak self] _ in
                            self?.presentPhotoPicker()
                          }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
