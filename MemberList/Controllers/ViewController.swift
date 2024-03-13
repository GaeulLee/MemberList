//
//  ViewController.swift
//  MemberList
//
//  Created by 이가을 on 3/12/24.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Property

    private let tableView = UITableView()
    
    var memberListManager = MemberListManager()
    
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        return button
    }()
    
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setDatas()
        setNavigationBar()
        setTableView()
        setTableViewConstraints()
    }
    
    // 바뀌거나 새로 등록된 멤버 정보를 업데이트 하기 위해 viewWillAppear 오버라이드!!
    // 커스텀 델리게이트를 사용하기 때문에 viewWillAppear 메서드 필요 X
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        tableView.reloadData()
//    }
    
    
    // MARK: - objc
    
    @objc func plusButtonTapped() {
        let detailVC = DetailViewController()
        
        detailVC.delegate = self // 여기에 대리자 설정이 안되어 있어서 새로운 멤버 추가시엔 커스텀 델리게이트가 작동하지 않았음...
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    // MARK: - Private

    private func setDatas() {
        memberListManager.makeMembersListDatas() // 일반적으로 서버에 요청
    }
    
    private func setNavigationBar() {
        title = "Members"
        
        // 네비게이션 설정관련
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 불투명
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 네비게이션 오른쪽 상단 버튼 설정
        self.navigationItem.rightBarButtonItem = self.plusButton
    }
    
    private func setTableView() {
        tableView.dataSource = self // 제발 까먹지 말자
        tableView.delegate = self
        
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MemberCell")
        tableView.rowHeight = 60
        
        view.addSubview(tableView)
    }

    private func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // print(#function)
        // print(memberListManager.getMembersList().count)
        
        return memberListManager.getMembersList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MyTableViewCell
        
        cell.member = memberListManager[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // move to next vc
        let detailVC = DetailViewController()
        detailVC.delegate = self
        
        let array = memberListManager.getMembersList()
        detailVC.member = array[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
}

// use custom delegate
extension ViewController: MemberDelegate {
    
    func addNewMember(_ member: Member) {
        memberListManager.makeNewMember(member)
        tableView.reloadData()
        
        print(#function)
        print(memberListManager.getMembersList().count)
    }
    
    func updateMember(index: Int, _ member: Member) {

        // print(#function)
        
        memberListManager.updateMemberInfo(index: index, member)
        tableView.reloadData()
    }
    
}

