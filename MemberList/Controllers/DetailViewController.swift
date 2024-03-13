//
//  DetailViewController.swift
//  MemberList
//
//  Created by 이가을 on 3/12/24.
//

import UIKit
import PhotosUI

final class DetailViewController: UIViewController {

    // MARK: - property

    private let detailView = DetailView()
    
    var member: Member?
    
    weak var delegate: MemberDelegate? // 강한 순환 참조가 발생하지 않도록 weak 사용

    
    // MARK: - viewDidLoad

    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
        setButtonAction()
        setTapGestures()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    // MARK: - private

    // vc에서 전달받은 데이터를 detailvc에 담는 메서ㄷ,
    private func setData() {
        detailView.member = member
    }
    
    
    // MARK: - 이미지뷰 눌러서 사진 변경
    
    // 제스쳐 설정 (이미지뷰가 눌리면, 실행)
    private func setTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        detailView.mainImageView.addGestureRecognizer(tapGesture)
        detailView.mainImageView.isUserInteractionEnabled = true
    }
    
    @objc func touchUpImageView() {
        print("이미지뷰 터치")
        setImagePicker()
    }
    
    // 피커뷰 설정
    private func setImagePicker() {
        // 기본설정 셋팅
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        
        // 기본설정을 가지고, 피커뷰컨트롤러 생성
        let picker = PHPickerViewController(configuration: configuration)
        // 피커뷰 컨트롤러의 대리자 설정
        picker.delegate = self
        // 피커뷰 띄우기
        self.present(picker, animated: true, completion: nil)
    }
    
    
    // MARK: - 뷰에 있는 버튼의 타겟 설정

    private func setButtonAction() {
        detailView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc func saveButtonTapped() {
        
        // 1) 멤버가 없다면 (새로운 멤버 추가)
        if member == nil {
            // 입력이 안되어 있다면 빈문자열로 저장
            let name = detailView.nameTextField.text ?? ""
            let age = Int(detailView.ageTextField.text ?? "")
            let phoneNumber = detailView.phoneNumberTextField.text ?? ""
            let address = detailView.addressTextField.text ?? ""
            
            // 새 멤버 생성
            var newMember = Member(name: name, age: age, phone: phoneNumber, address: address)
            newMember.memberImage = detailView.mainImageView.image
            
            // 새 멤버 등록
            // let index = navigationController!.viewControllers.count - 2
            // let vc = navigationController?.viewControllers[index] as! ViewController
            // vc.memberListManager.makeNewMember(newMember)
            
            // 델리게이트 방식으로 구현⭐️
            delegate?.addNewMember(newMember)
            
            print(#function)
            print(newMember.name!)
            
        // 2) 멤버가 있다면 (변경된 멤버 내용을 업데이트)
        } else {
            // 이미지뷰에 있는 이미지를 그대로 다시 멤버에 저장
            member!.memberImage = detailView.mainImageView.image
            
            let memberId = Int(detailView.memberIdTextField.text!) ?? 0
            member!.name = detailView.nameTextField.text ?? ""
            member!.age = Int(detailView.ageTextField.text ?? "") ?? 0
            member!.phone = detailView.phoneNumberTextField.text ?? ""
            member!.address = detailView.addressTextField.text ?? ""
            
            // 뷰에도 바뀐 멤버 전달
            detailView.member = member
            
            // 바뀐 멤버 수정
            // let index = navigationController!.viewControllers.count - 2
            // let vc = navigationController?.viewControllers[index] as! ViewController
            // vc.memberListManager.updateMemberInfo(index: memberId, member!)
            
            // 델리게이트 방식으로 구현⭐️
            delegate?.updateMember(index: memberId, member!)
        }
        
        // 전 화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
    }
}

// 이미지를 클릭해서 사진첩을 열 수 있도록 프로토콜 채택
extension DetailViewController: PHPickerViewControllerDelegate {
    
    // 필수 구현 메서드
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 피커뷰 dismiss
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    // 이미지뷰에 표시
                    self.detailView.mainImageView.image = image as? UIImage
                }
            }
        } else {
            print("이미지 불러오기 실패")
        }
    }
}
