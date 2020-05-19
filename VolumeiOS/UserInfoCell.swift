//
//  UserInfoCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/19/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class PersonInformationTableViewCell: UITableViewCell {
  private let title: String
  private let value: String
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(title: String, value: String) {
    self.title = title
    self.value = value
    super.init(style: .default, reuseIdentifier: "PersonInformationTableViewCell")
    
    setUpView()
  }
  
  private func setUpView() {
    let titleLabel = UILabel()
    titleLabel.text = title
    
    titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    
    let valueLabel = UILabel()
    valueLabel.text = value
    
    let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 5
    
    contentView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
    stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
    stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
    stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
    stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }
}
