//
//  DetailViewController.swift
//  MemberList
//
//  Created by 이가을 on 3/12/24.
//

import UIKit

final class DetailViewController: UIViewController {

    // MARK: - property

    private let detailView = DetailView()
    
    var member: Member?

    
    // MARK: - viewDidLoad

    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
        setButtonAction()

    }
    
    
    // MARK: - private

    // vc에서 전달받은 데이터를 detailvc에 담는 메서ㄷ,
    private func setData() {
        detailView.member = member
    }
 
    
    
    
    // 뷰에 있는 버튼의 타겟 설정
    func setButtonAction() {
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
            newMember.memberImage = detailView.mainImageView.image // ?
            
            // 새 멤버 등록
            let index = navigationController!.viewControllers.count - 2
            let vc = navigationController?.viewControllers[index] as! ViewController
            vc.memberListManager.makeNewMember(newMember)
            
        // 2) 멤버가 있다면 (변경된 멤버 내용을 업데이트)
        } else {
            // 이미지뷰에 있는 이미지를 그대로 다시 멤버에 저장
            member!.memberImage = detailView.mainImageView.image // ?
            
            let memberId = Int(detailView.memberIdTextField.text!) ?? 0
            member!.name = detailView.nameTextField.text ?? ""
            member!.age = Int(detailView.ageTextField.text ?? "") ?? 0
            member!.phone = detailView.phoneNumberTextField.text ?? ""
            member!.address = detailView.addressTextField.text ?? ""
            
            // 뷰에도 바뀐 멤버 전달 ??
            detailView.member = member
            
            // 바뀐 멤버 수정
            let index = navigationController!.viewControllers.count - 2
            let vc = navigationController?.viewControllers[index] as! ViewController
            vc.memberListManager.updateMemberInfo(index: memberId, member!)
        }
        
        // 전 화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
    }
}
