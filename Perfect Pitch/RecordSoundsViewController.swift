//
//  ViewController.swift
//  Perfect Pitch
//
//  Created by Xing Hui Lu on 2/2/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    // MARK: - View Controller Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the stop button
        stopButton.isHidden = true
        recordButton.isEnabled = true
    }

    // MARK: - IBAction methods
    
    @IBAction func recordAudio(_ sender: UIButton) {
        stopButton.isHidden = false
        recordingInProgress.text = "Recording..."
        
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
        recordingInProgress.text = "Tap to Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - AVAudioRecorder delegate methods
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // Reference to the audio file that was actually recorded to the phone
            let url = recorder.url
            
            // Name of the recorded file
            let title = recorder.url.lastPathComponent
            
            recordedAudio = RecordedAudio(fileURL: url, title: title)
            performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.isEnabled = true
            stopButton.isHidden = true
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
}

