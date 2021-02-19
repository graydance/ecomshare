package fun.wqiang.ecomshare;

import android.util.Log;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** EcomsharePlugin */
public class EcomsharePlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  public static final String MEDIA_TYPE_IMAGE = "image";
  public static final String MEDIA_TYPE_TEXT = "text";

  public static final String CHANNEL_INSTAGRAM = "instagram";
  public static final String CHANNEL_FACEBOOK = "facebook";
  public static final String CHANNEL_FACEBOOK_GROUP = "facebook group";
  public static final String CHANNEL_FACEBOOK_PAGE = "facebook page";
  public static final String CHANNEL_FACEBOOK_MARKET_PLACE = "facebook market place";
  public static final String CHANNEL_TWITTER = "twitter";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ecomshare");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getSupportedChannels")) {
      final List<String> list = new ArrayList<>();
      // TODO
      if (call.arguments.equals(MEDIA_TYPE_IMAGE)) {
        list.add(CHANNEL_FACEBOOK_MARKET_PLACE);
      }
      list.add(CHANNEL_INSTAGRAM);
      list.add(CHANNEL_FACEBOOK);
      list.add(CHANNEL_FACEBOOK_GROUP);
      list.add(CHANNEL_FACEBOOK_PAGE);
      list.add(CHANNEL_TWITTER);
      result.success(list);
    } else if (call.method.equals("shareTo")){
      String mediaType = call.argument("mediaType");
      String channel = call.argument("channel");
      String content = call.argument("content");
      // TODO
      result.error("TODO", String.format("%s-%s", mediaType, channel), content);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
