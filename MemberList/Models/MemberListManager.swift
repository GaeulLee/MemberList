//
//  MemberListManager.swift
//  MemberList
//
//  Created by 이가을 on 3/12/24.
//

import Foundation

final class MemberListManager {
    
    private var membersList: [Member] = []
    
    func makeMembersListDatas() {
        membersList = [
            Member(name: "홍길동", age: 20, phone: "010-1111-2222", address: "서울"),
            Member(name: "임꺽정", age: 23, phone: "010-3333-4444", address: "서울"),
            Member(name: "스티브", age: 50, phone: "010-5555-6666", address: "미국"),
            Member(name: "쿡", age: 30, phone: "010-5555-5555", address: "캘리포니아"),
            Member(name: "베조스", age: 50, phone: "010-2222-2222", address: "하와이"),
            Member(name: "배트맨", age: 40, phone: "010-7777-7777", address: "고담시티"),
            Member(name: "조커", age: 40, phone: "010-1234-1234", address: "고담시티")
        ]
    }
    
    // 전체 멤버 리스트 얻기
    func getMembersList() -> [Member] {
        return membersList
    }
    
    // 새로운 멤버 만들기
    func makeNewMember(_ member: Member) {
        membersList.append(member)
    }
    
    // 기존 멤버 정보 업데이트
    func updateMemberInfo(index: Int, _ member: Member) {
        membersList[index] = member
    }
    
    // 특정 멤버 얻기
    subscript(index: Int) -> Member {
        get{
            return membersList[index]
        }
        set{
            membersList[index] = newValue
        }
    }
    
}
