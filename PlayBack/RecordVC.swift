//
//  RecordVC.swift
//  PlayBack
//
//  Created by BAM on 2017-09-29.
//  Copyright © 2017 BAM. All rights reserved.
//

import UIKit
import AVFoundation

class RecordVC: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var textLabel: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var recorder : AVAudioRecorder?
    var player : AVAudioPlayer?
    var url : URL?
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = false
        addButton.isEnabled = false
        setupRecorder()

    }
    
    func setupRecorder(){
        do {
            //Create AudioRecorderSession
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
        
        //Create AudioRecorderURL
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [path, "audio.m4a"]
            url = NSURL.fileURL(withPathComponents: pathComponents)
            print("URL: \(url)")
        
        //Create AudioRecorderSettings
            var settings : [String : Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100
            settings[AVNumberOfChannelsKey] = 2
        
        //Create AudioRecorderObj
           try recorder = AVAudioRecorder(url: url!, settings: settings)
            recorder!.prepareToRecord()
            
        } catch let error as NSError{
            print("Error: \(error)")
        }
    }

    @IBAction func recordTapped(_ sender: Any) {
        if recorder!.isRecording{
            recorder?.stop()
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        } else {
            recorder?.record()
            recordButton.setTitle("Stop", for: .normal)
        }
    }

    @IBAction func playTapped(_ sender: Any) {
        do{
            try player = AVAudioPlayer(contentsOf: url!)
            player!.play()
        } catch {
            print(error)
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let sound = Sound(context: appDel.persistentContainer.viewContext)
        sound.name = textLabel.text
        do{
            try sound.audio = Data(contentsOf: url!)
            appDel.saveContext()
        } catch {
            print(error)
        }
        navigationController?.popViewController(animated: true)
    }
    
}
