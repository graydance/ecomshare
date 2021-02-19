import Flutter
import UIKit

public class SwiftEcomsharePlugin: NSObject, FlutterPlugin {
  static let MEDIA_TYPE_IMAGE = "image";
  static let MEDIA_TYPE_TEXT = "text";

  static let CHANNEL_INSTAGRAM = "instagram";
  static let CHANNEL_FACEBOOK = "facebook";
  static let CHANNEL_FACEBOOK_GROUP = "facebook group";
  static let CHANNEL_FACEBOOK_PAGE = "facebook page";
  static let CHANNEL_FACEBOOK_MARKET_PLACE = "facebook market place";

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ecomshare", binaryMessenger: registrar.messenger())
    let instance = SwiftEcomsharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getSupportedChannels") {
        var list = [String]()
        if ((call.arguments as? String) == SwiftEcomsharePlugin.MEDIA_TYPE_IMAGE) {
            list.append(SwiftEcomsharePlugin.CHANNEL_FACEBOOK_MARKET_PLACE);
        }
        list.append(SwiftEcomsharePlugin.CHANNEL_INSTAGRAM)
        list.append(SwiftEcomsharePlugin.CHANNEL_FACEBOOK)
        list.append(SwiftEcomsharePlugin.CHANNEL_FACEBOOK_GROUP)
        list.append(SwiftEcomsharePlugin.CHANNEL_FACEBOOK_MARKET_PLACE)
        result(list)
    } else if (call.method == "shareTo") {
        if let args = call.arguments as? Dictionary<String, String> {
            let mediaType = args["mediaType"]!;
            let channel = args["channel"]!;
            let content = args["content"]!;
            result(FlutterError.init(code:"TODO", message: mediaType + "-" + channel, details: content))
        }
    } else {
        result(FlutterMethodNotImplemented)
    }
  }
}
