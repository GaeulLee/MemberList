//
//  Member.swift
//  MemberList
//
//  Created by 이가을 on 3/12/24.
//

import UIKit


// custom delegate
protocol MemberDelegate: AnyObject { // AnyObject: 클래스에서만 채택할 수 있는 프로토콜
    func addNewMember(_ member: Member)
    func updateMember(index: Int, _ member: Member)
}


struct Member {
    // 지연 저장 속성
    lazy var memberImage: UIImage? = {
        // 이름이 없다면, 시스템 사람 이미지 셋팅
        guard let name = name else {
            return UIImage(systemName: "person")
        }
        // 해당 이름으로 된 이미지가 없다면, 시스템 사람이미지 셋팅
        return UIImage(named: "\(name).png") ?? UIImage(systemName: "person")
    }()
    
    static var memberNumbers: Int = 0 // 멤버의 (절대적) 순서를 위한 타입 저장 속성
    let memberID: Int
    var name: String?
    var age: Int?
    var phone: String?
    var address: String?
    
    // 생성자 구현
    init(name: String?, age: Int?, phone: String?, address: String?) {
        
        // 타입저장속성의 절대적 값으로 셋팅 (자동순번)
        self.memberID = Member.memberNumbers
        
        // 나머지 저장속성은 외부에서 셋팅
        self.name = name
        self.age = age
        self.phone = phone
        self.address = address
        
        // 멤버를 생성한다면, 항상 타입저장속성의 정수값 +1
        Member.memberNumbers += 1
    }
}
