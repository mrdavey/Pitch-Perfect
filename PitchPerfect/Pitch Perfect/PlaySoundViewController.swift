//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by David Truong on 12/04/2015.
//  Copyright (c) 2015 David Truong. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audio: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        audio = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audio.enableRate = true

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    @IBAction func snailButton(sender: UIButton) {
        stopAndResetAudioEngine()
        audio.stop()
        audio.rate = 0.5
        audio.currentTime = 0
        audio.play()

    }

    @IBAction func rabbitButton(sender: UIButton) {
        stopAndResetAudioEngine()
        audio.rate = 1.5
        audio.currentTime = 0
        audio.play()
    }

    @IBAction func chipMunkButton(sender: UIButton) {
        playAudioWithEffect("changePitch", variable: 1000)
    }

    @IBAction func darthVaderButton(sender: UIButton) {
        playAudioWithEffect("changePitch", variable: -1000)
    }
    
    @IBAction func parrotButton(sender: UIButton) {
        playAudioWithEffect("echoEffect", variable: 50)
    }

    @IBAction func reverbButton(sender: UIButton) {
        playAudioWithEffect("reverbEffect", variable: 70)
    }


    @IBAction func stopButton(sender: UIButton) {
        stopAndResetAudioEngine()
    }

    func playAudioWithEffect(type: String, variable: Float){
        stopAndResetAudioEngine()

        var audioPlayerNode = AVAudioPlayerNode()
        var audioEngineConnect: AnyObject
        audioEngine.attachNode(audioPlayerNode)

        switch type {
        case "changePitch":
            var changePitchEffect = AVAudioUnitTimePitch()
            changePitchEffect.pitch = variable //-2400 to 2400
            audioEngine.attachNode(changePitchEffect)
            audioEngineConnect = changePitchEffect
        case "reverbEffect":
            var reverbEffect = AVAudioUnitReverb()
            reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
            reverbEffect.wetDryMix = variable //between 0 and 100
            audioEngine.attachNode(reverbEffect)
            audioEngineConnect = reverbEffect
        case "echoEffect":
            var echoEffect = AVAudioUnitDelay()
            echoEffect.feedback = variable //-100 to 100
            audioEngine.attachNode(echoEffect)
            audioEngineConnect = echoEffect
        default:
            println("invalid type given, defaulting to pitch change")
            var changePitchEffect = AVAudioUnitTimePitch()
            changePitchEffect.pitch = variable //-2400 to 2400
            audioEngine.attachNode(changePitchEffect)
            audioEngineConnect = changePitchEffect
        }

        audioEngine.connect(audioPlayerNode, to: audioEngineConnect as! AVAudioNode, format: nil)
        audioEngine.connect(audioEngineConnect as! AVAudioNode, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
    }

    func stopAndResetAudioEngine() {
        audio.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}
