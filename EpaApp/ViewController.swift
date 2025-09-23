import UIKit
import WebKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    var playerController: AVPlayerViewController?
    var player: AVPlayer?
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioSession()
        playVideo()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "epa_splash", ofType: "mp4") else {
            debugPrint("epa_splash.mp4 not found")
            return
        }
        
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        player = AVPlayer(playerItem: playerItem)
        
        playerController = AVPlayerViewController()
        playerController?.showsPlaybackControls = false
        playerController?.player = player
        
        // Set the background color of AVPlayerViewController's view to white
        playerController?.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        addChild(playerController!)
        playerController?.view.frame = view.bounds
        view.addSubview(playerController!.view)
        playerController?.didMove(toParent: self)
        
        player?.play()
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Method, video is finished ")
        player?.pause()
        playerController?.willMove(toParent: nil)
        playerController?.view.removeFromSuperview()
        playerController?.removeFromParent()
        
        showWebView()
    }
    
    private func showWebView() {
        if webView == nil {
            if let url = URL(string: "https://epabusiness.com") {
                let config = WKWebViewConfiguration()
                let preferences = WKWebpagePreferences()
                preferences.allowsContentJavaScript = true
                
                config.defaultWebpagePreferences = preferences
                
                let webView = WKWebView(frame: view.bounds, configuration: config)
                webView.navigationDelegate = self
                
                webView.load(URLRequest(url: url))
                
                view.addSubview(webView)
                self.webView = webView
                
                // Constrain the web view to cover the entire view
                webView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    webView.topAnchor.constraint(equalTo: view.topAnchor),
                    webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
            } else {
                print("Invalid URL")
            }
        }
    }
}

extension ViewController: WKNavigationDelegate {
    // Handle navigation events if needed
}
