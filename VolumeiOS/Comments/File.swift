import Foundation
import UIKit
import Combine

class TestTextView: UIViewController {
    let countLabel = UILabel()
   
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        navigationController?.isToolbarHidden = true
        setupCountLabel()
       
    }
    
    func setupCountLabel() {
            countLabel.text = "Hello World"
            countLabel.textColor = UIColor.black
            view.addSubview(countLabel)
            countLabel.translatesAutoresizingMaskIntoConstraints = false
            countLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            countLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            countLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            
        }


    
    
   
    
}
