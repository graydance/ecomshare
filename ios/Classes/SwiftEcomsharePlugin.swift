import Flutter
import FBSDKCoreKit
import FBSDKShareKit

public class SwiftEcomsharePlugin: NSObject, FlutterPlugin {
    
    public enum MediaType: String {
        case text, image, video
    }
    
    public enum Channel: String, CaseIterable {
        case instagram = "Instagram"
        case facebook = "Facebook"
        case twitter = "Twitter"
        case system = "System"
        
        func isSupported(mediaType: MediaType) -> Bool {
            switch self {
            case .instagram:
                guard canOpenInstagram() else {
                    return false
                }
                return [MediaType.image].contains(mediaType)
            case .facebook:
                return canOpenFacebook()
            case .twitter:
                guard canOpenTwitter() else {
                    return false
                }
                return [MediaType.text].contains(mediaType)
            case .system:
                return true
            }
        }
    }
    
    public enum FlutterMethod: String {
        case getSupportedChannels, shareTo
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ecomshare", binaryMessenger: registrar.messenger())
        let instance = SwiftEcomsharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = FlutterMethod(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        switch method {
        case .getSupportedChannels:
            guard let args = call.arguments as? String,
                  let mediaType = MediaType(rawValue: args) else {
                result(FlutterError(code: "arguments is invalid", message: "arguments is invalid", details: call.arguments))
                return
            }
            result(Channel.allCases.filter { $0.isSupported(mediaType: mediaType) }.map { $0.rawValue })
        case .shareTo:
            guard let args = call.arguments as? [String: String],
                  let channel = Channel(rawValue: args["channel"] ?? ""),
                  let mediaType = MediaType(rawValue: args["mediaType"] ?? ""),
                  let content = args["content"] else {
                result(FlutterError(code: "arguments is invalid", message: "arguments is invalid", details: call.arguments))
                return
            }
            
            switch channel {
            case .instagram:
                shareToInstagram(imagePath: content, result: result)
            case .facebook:
                let images = (args["images"] as? [String]) ?? []
                shareToFacebook(mediaType: mediaType, content: content, images: images, result: result)
            case .twitter:
                shareToTwitter(text: content, result: result)
            case .system:
                shareBySystem(content: content, result: result)
            }
        }
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions as? [UIApplication.LaunchOptionsKey: Any])
        return true
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue, annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // MARK: - Private
    
    private lazy var _shareInstagram = ShareInstagram()
    
    private static func canOpenFacebook() -> Bool {
        return true
    }
    
    private static func canOpenInstagram() -> Bool {
        let url = URL(string: "instagram://app")!
        return UIApplication.shared.canOpenURL(url)
    }
    
    private static func canOpenTwitter() -> Bool {
        let url = URL(string: "twitter://")!
        return UIApplication.shared.canOpenURL(url)
    }
    
    private func shareToFacebook(mediaType: MediaType, content: String, images: [String], result: @escaping FlutterResult) {
        let sharingContent: SharingContent? = {
            switch mediaType {
            case .text:
                guard let url = URL(string: content) else {
                    result(false)
                    return nil
                }
                let content = ShareLinkContent()
                content.contentURL = url
                return content
            case .image:
                let content = SharePhotoContent()
                content.photos = images.map({ filePath in
                    let url = URL(fileURLWithPath: filePath)
                    let photo = SharePhoto(imageURL: url, userGenerated: true)
                    return photo
                })
                return content
            case .video:
                let url = URL(fileURLWithPath: content)
                let video = ShareVideo(videoURL: url)
                let content = ShareVideoContent()
                content.video = video
                return content
            }
        }()
        
        guard let theSharingContent = sharingContent else {
            result(false)
            return
        }
        guard let controller = UIApplication.shared.windows.first?.rootViewController else {
            result(false)
            return
        }
        let rst = ShareDialog(fromViewController: controller, content: theSharingContent, delegate: nil).show()
        result(rst)
    }
    
    private func shareToInstagram(imagePath: String, result: @escaping FlutterResult) {
        guard SwiftEcomsharePlugin.canOpenInstagram() else {
            result(false)
            return
        }
        guard let controller = UIApplication.shared.windows.first?.rootViewController else {
            result(false)
            return
        }
        guard let image = UIImage(contentsOfFile: imagePath) else {
            result(false)
            return
        }
        
        _shareInstagram.postToFeed(image: image, caption: "", bounds: controller.view.bounds, view: controller.view)
    }
    
    private func shareToTwitter(text: String, result: @escaping FlutterResult) {
        if #available(iOS 10.0, *) {
            let url = URL(string: "twitter://post?message=\(text)")!
            guard UIApplication.shared.canOpenURL(url) else {
                result(false)
                return
            }
            UIApplication.shared.open(url, options: [:]) { isSuccess in
                result(isSuccess)
            }
        } else {
            let url = URL(string: "https://twitter.com/intent/tweet?text=\(text)")!
            UIApplication.shared.openURL(url)
        }
    }
    
    private func shareBySystem(content: String, result: @escaping FlutterResult) {
        guard let controller = UIApplication.shared.windows.first?.rootViewController else {
            result(false)
            return
        }
        let url = URL(fileURLWithPath: content)
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        controller.present(activityViewController, animated: true, completion: nil)
        result(true)
    }
}
