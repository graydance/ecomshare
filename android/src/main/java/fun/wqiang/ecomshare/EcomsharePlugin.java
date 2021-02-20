package fun.wqiang.ecomshare;

import android.app.Activity;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * EcomsharePlugin
 */
public class EcomsharePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Activity activity;
    private static final String METHOD_GET_SUPPORTED_CHANNELS = "getSupportedChannels";
    private static final String METHOD_SHARE_TO = "shareTo";

    public static final String MEDIA_TYPE_IMAGE = "image";
    public static final String MEDIA_TYPE_TEXT = "text";

    public static final String CHANNEL_INSTAGRAM = "instagram";
    public static final String CHANNEL_FACEBOOK = "facebook";
    public static final String CHANNEL_FACEBOOK_GROUP = "facebook group";
    public static final String CHANNEL_FACEBOOK_PAGE = "facebook page";
    public static final String CHANNEL_FACEBOOK_MARKET_PLACE = "facebook market place";
    public static final String CHANNEL_TWITTER = "twitter";
    public static final String CHANNEL_SYSTEM = "system";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ecomshare");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (METHOD_GET_SUPPORTED_CHANNELS.equals(call.method)) {
            final List<String> list = new ArrayList<>();
//            if (call.arguments.equals(MEDIA_TYPE_IMAGE)) {
//                list.add(CHANNEL_FACEBOOK_MARKET_PLACE);
//            }
//            list.add(CHANNEL_FACEBOOK_GROUP);
//            list.add(CHANNEL_FACEBOOK_PAGE);
            list.add(CHANNEL_INSTAGRAM);
            list.add(CHANNEL_FACEBOOK);
            list.add(CHANNEL_TWITTER);
            list.add(CHANNEL_SYSTEM);
            result.success(list);
        } else if (METHOD_SHARE_TO.equals(call.method)) {
            String mediaType = call.argument("mediaType");
            String channel = call.argument("channel");
            String content = call.argument("content");
            if (CHANNEL_FACEBOOK.equals(channel)) {
                ShareManager.getInstance(activity).shareMedia2FacebookByIntent(content);
            } else if (CHANNEL_TWITTER.equals(channel)) {
                if (MEDIA_TYPE_TEXT.equals(mediaType)) {
                    ShareManager.getInstance(activity).share2Twitter(content, "");
                } else {
                    ShareManager.getInstance(activity).share2Twitter("", content);
                }
            } else if (CHANNEL_INSTAGRAM.equals(channel)) {
                ShareManager.getInstance(activity).share2Instagram(activity.getString(R.string.social_instagram), content);
            } else if(CHANNEL_SYSTEM.equals(channel)){
                ShareManager.getInstance(activity).shareBySystemShareComponent(null, content);
            }else {
                result.error("-999", "Unknown channel", "Unknown channel, share failure");
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
