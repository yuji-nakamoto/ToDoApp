//
//  Tutorial3ViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/29.
//

import UIKit
import AVFoundation

class Tutorial3ViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var videoHeight: NSLayoutConstraint!
    @IBOutlet weak var videoWidth: NSLayoutConstraint!
    @IBOutlet weak var stackTopConst: NSLayoutConstraint!
    @IBOutlet weak var videoTopConst: NSLayoutConstraint!
    
    private var videoPlayer: AVPlayer!
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 35 / 2
        hintView.backgroundColor = .clear
        hintView.alpha = 0
        showHintView()
    }
    
    private func showHintView() {
        setupVideoViewHeight()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            visualEffectView.alpha = 0
            visualEffectView.frame = self.view.frame
            view.addSubview(visualEffectView)
            view.addSubview(hintView)
            
            UIView.animate(withDuration: 0.7) { [self] in
                visualEffectView.alpha = 1
                hintView.alpha = 1
                setVideoPlayer()
            }
        }
    }
    
    private func setupVideoViewHeight() {
        
        print(UIScreen.main.nativeBounds.height)
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            videoHeight.constant = 380
            stackTopConst.constant = 10
            videoTopConst.constant = 10
            break
        case 1792:
            videoHeight.constant = 530
            videoWidth.constant = 350
            break
        case 2208:
            videoHeight.constant = 440
            break
        case 2532:
            videoHeight.constant = 480
            break
        case 2688:
            videoHeight.constant = 530
            videoWidth.constant = 350
            break
        case 2778:
            videoHeight.constant = 560
            videoWidth.constant = 350
            break
        default:
            break
        }
    }
    
    private func setVideoPlayer() {
        
        guard let path = Bundle.main.path(forResource: "tutorial3", ofType: "mp4") else {
            fatalError("Movie file can not find.")
        }
        let fileURL = URL(fileURLWithPath: path)
        let avAsset = AVURLAsset(url: fileURL)
        let playerItem: AVPlayerItem = AVPlayerItem(asset: avAsset)
        
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        let layer = AVPlayerLayer()
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        layer.player = videoPlayer
        layer.frame = videoView.bounds
        videoView.layer.addSublayer(layer)
        
        seekBar.minimumValue = 0
        seekBar.maximumValue = Float(CMTimeGetSeconds(avAsset.duration))
        
        let interval : Double = Double(0.5 * seekBar.maximumValue) / Double(seekBar.bounds.maxX)
        
        let time : CMTime = CMTimeMakeWithSeconds(interval, preferredTimescale: Int32(NSEC_PER_SEC))
        
        videoPlayer.addPeriodicTimeObserver(forInterval: time, queue: nil, using: {time in
            
            let duration = CMTimeGetSeconds(self.videoPlayer.currentItem!.duration)
            let time = CMTimeGetSeconds(self.videoPlayer.currentTime())
            let value = Float(self.seekBar.maximumValue - self.seekBar.minimumValue) * Float(time) / Float(duration) + Float(self.seekBar.minimumValue)
            self.seekBar.value = value
        })
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
    
    @IBAction func onSider(_ sender: UISlider) {
        videoPlayer.seek(to: CMTimeMakeWithSeconds(Float64(seekBar.value), preferredTimescale: Int32(NSEC_PER_SEC)))
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension Tutorial3ViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
