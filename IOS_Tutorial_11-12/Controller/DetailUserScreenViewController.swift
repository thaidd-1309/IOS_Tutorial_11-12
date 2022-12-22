//
//  DetailUserScreenViewController.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thái on 21/12/2022.
//

import UIKit

final class DetailUserScreenViewController: UIViewController {
    @IBOutlet private weak var nameAndAddressLabel: UILabel!
    @IBOutlet private weak var nameSkillLabel: UILabel!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var followingButton: UIButton!
    @IBOutlet private weak var followerButton: UIButton!
    @IBOutlet private weak var numberRespositoryLabel: UILabel!
    @IBOutlet private weak var numberFollowingLabel: UILabel!
    @IBOutlet private weak var numberFollowerLabel: UILabel!
    @IBOutlet private weak var containInformView: UIView!
    @IBOutlet private weak var listUserTableView: UITableView!
    
    private var followerButtonIsSelected = true
    private let callAPI = APICaller.shared
    private var userRepository = UserRepository()
    private var followers = [User]()
    private var following = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        userImageView.circleView()
        containInformView.layer.cornerRadius = 40
        configFollowerAndFollowingButton()
    }
    
    func bindData (user: User) {
        self.callAPI.getImage(imageURL: (user.avatarUrl)) { [weak self] (data, error)  in
            guard let self = self else { return }
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.userImageView.image = UIImage(data: data)
                }
            }
        }
        self.updateInformUser(name: user.login)
        self.getInformFollow(name: user.login)
    }
    
    private func updateInformUser (name: String) {
        userRepository.getInformUser(name: name) {  [weak self] (data, error) in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.upadateLabelName(data: data)
                }
          }
        }
    }
    
    private func upadateLabelName(data: UserDetail) {
        self.nameAndAddressLabel.text = "\(data.name ?? "no name")*\(data.location ?? "")"
        self.numberFollowerLabel.text = "\(data.followers ?? 0)"
        self.numberFollowingLabel.text = "\(data.following ?? 0)"
        self.numberRespositoryLabel.text = "\(data.publicRepos ?? 0)"
        self.nameSkillLabel.text = "\(data.bio ?? "no bio")"
    }
    
    private func getInformFollow(name: String) {
        userRepository.getFollowersUsers(name: name) { [weak self] (data, error) in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            if let data = data {
                self.followers = data
                DispatchQueue.main.async {
                    self.listUserTableView.reloadData()
                }
            }
        }
        
        userRepository.getFollowingUsers(name: name) { [weak self] (data, error) in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            if let data = data {
                self.following = data
            }
        }
    }
    
    private func configFollowerAndFollowingButton() {
        followerButton.topCornerRadius(cornerRadius: 10)
        followingButton.topCornerRadius(cornerRadius: 10)
        if followerButtonIsSelected {
            followerButton.backgroundColor = .white
            followerButton.tintColor = UIColor(#colorLiteral(red: 0.2822310925, green: 0.3429890871, blue: 0.3248010278, alpha: 1))
            followingButton.backgroundColor = UIColor(#colorLiteral(red: 0.2822310925, green: 0.3429890871, blue: 0.3248010278, alpha: 1))
            followingButton.tintColor = .white
        } else {
            followingButton.backgroundColor = .white
            followingButton.tintColor = UIColor(#colorLiteral(red: 0.2822310925, green: 0.3429890871, blue: 0.3248010278, alpha: 1))
            followerButton.backgroundColor = UIColor(#colorLiteral(red: 0.2822310925, green: 0.3429890871, blue: 0.3248010278, alpha: 1))
            followerButton.tintColor = .white
        }
    }
    
    @IBAction private func followerButtonTapped(_ sender: Any) {
        if followerButtonIsSelected == false {
            followerButtonIsSelected = true
            configFollowerAndFollowingButton()
            DispatchQueue.main.async {
                self.listUserTableView.reloadData()
            }
        }
    }
    
    @IBAction private func FollowingButtonTapped(_ sender: Any) {
        if followerButtonIsSelected {
            followerButtonIsSelected = false
            configFollowerAndFollowingButton()
            DispatchQueue.main.async {
                self.listUserTableView.reloadData()
            }
        }
    }
}

extension DetailUserScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerButtonIsSelected ? followers.count : following.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserTableViewCell.self)
        followerButtonIsSelected ? cell.bindData(user: followers[indexPath.row]) : cell.bindData(user: following[indexPath.row])
        return cell
    }
}

extension DetailUserScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailScreen = storyBoard.instantiateViewController(withIdentifier: "DetailUserScreenViewController") as? DetailUserScreenViewController
        followerButtonIsSelected ? detailScreen?.bindData(user: followers[indexPath.row]) :             detailScreen?.bindData(user: following[indexPath.row])
        self.navigationController?.pushViewController(detailScreen!, animated: true)
    }
}
