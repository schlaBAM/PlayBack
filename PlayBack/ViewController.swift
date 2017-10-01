//
//  ViewController.swift
//  PlayBack
//
//  Created by BAM on 2017-09-29.
//  Copyright © 2017 BAM. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var sounds : [Sound] = []
    var audioPlayer : AVAudioPlayer?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getSounds()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let player = audioPlayer {
            if player.isPlaying{
                player.stop()
            }
        }
    }

    func getSounds(){
        do{
            sounds = try context.fetch(Sound.fetchRequest())
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = sounds[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sound = sounds[indexPath.row]
        do {
            try audioPlayer = AVAudioPlayer(data: sound.audio!)
            audioPlayer?.play()
        } catch {
            print(error)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(sounds[indexPath.row])
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            getSounds()
        }
    }
}

