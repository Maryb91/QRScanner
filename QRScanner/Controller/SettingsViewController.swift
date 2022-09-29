//
//  SettingsViewController.swift
//  QRScanner
//
//  Created by Mariam B on 5/8/2022.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    //MARK: - Variables
    
    let items = ["About us", "Privacy policy", "Terms of service", "Vibrate","Contact us"]
    let vSwitch = UISwitch(frame: CGRect.zero) as UISwitch
    let userDefaults = UserDefaults.standard

   //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()


    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        if(indexPath.row == 3){
            vSwitch.isOn = userDefaults.bool(forKey: "vibrate")
            vSwitch.addTarget(self, action: #selector(vibrateSwitch), for: .valueChanged)
            vSwitch.tag = indexPath.row
            cell.accessoryView = vSwitch
        }

        return cell
    }
    

    
   //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSettingsDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SettingsItemViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.labelTitle = items[indexPath.row]
        }
    }
    
    //MARK: - Turn On and Off the vibrations
    
    @objc func vibrateSwitch() {
        var vibrateStatus : Bool = false

        if vSwitch.isOn == true {  
            vibrateStatus = true
        }
        else {
            vibrateStatus = false
        }
       userDefaults.set(vibrateStatus, forKey: "vibrate")

    }
    
}
