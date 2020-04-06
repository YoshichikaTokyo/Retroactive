//
//  CatchViewController.swift
//  Retroactive
//
//  Created by Tyshawn on 4/5/20.
//

import Foundation
import AVKit

class CatchViewController: NSViewController {
    @IBOutlet weak var virtualMachineBox: NSBox!
    @IBOutlet weak var chosenAppVMTitleField: NSTextField!
    @IBOutlet weak var chosenAppVMDescriptionField: NSTextField!
    @IBOutlet weak var currentVMIconImageView: NSImageView!
    @IBOutlet weak var workaroundButton: HoverButton!
    @IBOutlet weak var workaroundLearnMoreButton: HoverButton!
    
    static func instantiate() -> CatchViewController {
        return NSStoryboard.standard!.instantiateController(withIdentifier: "CatchViewController") as! CatchViewController
    }
    
    override func viewDidLoad() {
        let showiTunesWorkaround = AppManager.shared.needsToShowiTunesWorkaround
        workaroundButton.isHidden = !showiTunesWorkaround
        workaroundLearnMoreButton.isHidden = !showiTunesWorkaround
        if (showiTunesWorkaround) {
            workaroundButton.title = "Get Apple Configurator 2".localized() + " ↗"
            workaroundLearnMoreButton.title = "Learn how to download an iOS app with Apple Configurator 2".localized() + " ↗"
        }
        chosenAppVMTitleField.stringValue = AppManager.shared.chosenAppVMTitle
        chosenAppVMDescriptionField.stringValue = AppManager.shared.chosenAppVMDescription
        currentVMIconImageView.image = AppManager.shared.currentVMImage
    }

    @IBAction func workaroundClicked(_ sender: Any) {
        AppDelegate.current.safelyOpenURL("macappstore://apps.apple.com/app/apple-configurator-2/id1037126344")
    }
    
    @IBAction func workaroundLearnMoreClicked(_ sender: Any) {
        let tutorialVC = TutorialViewController.instantiate()
        self.presentAsSheet(tutorialVC)
    }
}

class TutorialViewController: NSViewController {
    @IBOutlet weak var playerView: AVPlayerView!
    var player: AVPlayer?
    @IBOutlet weak var closeButton: HoverButton!
    
    static func instantiate() -> TutorialViewController {
        return NSStoryboard.standard!.instantiateController(withIdentifier: "TutorialViewController") as! TutorialViewController
    }
    
    override func viewDidLoad() {
        guard let videoURL = Bundle.main.url(forResource: "ConfiguratorTutorial", withExtension: "mp4") else {
            return
        }
        closeButton.alphaValue = 0
        player = AVPlayer(url: videoURL)
        playerView.player = player
    }
    
    override func viewDidAppear() {
        player?.play()
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        player?.pause()
        self.dismiss(self)
    }
    
    override func mouseEntered(with event: NSEvent) {
        closeButton.animator().alphaValue = 1.0
    }
    
    override func mouseExited(with event: NSEvent) {
        closeButton.animator().alphaValue = 0
    }
    
}
