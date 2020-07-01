//
//  ResultViewController.swift
//  CIFilterMixer
//
//  Created by 佐藤 慎 on 2020/06/26.
//  Copyright © 2020 STSN. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    public var effects: [String] = []

    static func makeInstance(effects: [String]) -> ResultViewController {
        guard let vc = UIStoryboard.makeInitialViewController(storyboardName: "Result") as? ResultViewController else {
            fatalError()
        }
        vc.effects = effects
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.effects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = self.effects[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
}
