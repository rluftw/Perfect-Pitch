//
//  PlaySoundsViewController.swift
//  Perfect Pitch
//
//  Created by Xing Hui Lu on 2/2/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try! AVAudioPlayer(contentsOf: receivedAudio.fileURL as URL)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.fileURL as URL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playDarthvaderAudio(_ sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    @IBAction func playChipmunkAudio(_ sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    @IBAction func playSlowAudio(_ sender: UIButton) {
        playAudio(0.5)
    }
    
    
    @IBAction func playFastAudio(_ sender: UIButton) {
        playAudio(1.5)
    }
    
    
    @IBAction func stopAudio(_ sender: UIButton) {
        audioPlayer.stop()
    }
    
    // MARK: - Helper methods
    
    func playAudio(_ rate: Float) {
        stopAndResetAudio()
        
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(_ pitch: Float) {
        stopAndResetAudio()
        
        // Make an AVAudioPlayerNode and attach it onto the engine
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        
        // Make a AVAudioUnitTimePitch and attach it onto the engine
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        // Connect the player with effect
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    
        // Schedule to play the entire audio file
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
        // Start the engine
        try! audioEngine.start()
        
        // Start playing!
        audioPlayerNode.play()
    }
    
    func stopAndResetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        
        // Resets all audio nodes in the audio engine
        audioEngine.reset()
    }
}
