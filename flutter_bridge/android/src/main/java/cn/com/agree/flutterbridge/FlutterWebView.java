package cn.com.agree.flutterbridge;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Build;
import android.view.View;
import android.webkit.WebView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.platform.PlatformView;

/**
 * Author: zhaomenghuan
 * Email: zhaomenghuan@agree.com.cn
 * Date：2018/12/24.
 */
public class FlutterWebView implements PlatformView, MethodCallHandler {
    private static String TAG = FlutterWebView.class.getName();

    private final WebView webView;
    private final MethodChannel methodChannel;

    @SuppressLint("SetJavaScriptEnabled")
    @SuppressWarnings("unchecked")
    FlutterWebView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
        webView = new WebView(context);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            WebView.setWebContentsDebuggingEnabled(true);
        }
        webView.getSettings().setJavaScriptEnabled(true);

//        if (params.containsKey("url")) {
//            String url = (String) params.get("url");
//            Log.e(TAG, url);
//            webView.loadUrl(url);
//        }

        methodChannel = new MethodChannel(messenger, "plugins.flutter.io/webview_" + id);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public View getView() {
        return webView;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "loadUrl":
                loadUrl(methodCall, result);
                break;
            case "updateSettings":
                updateSettings(methodCall, result);
                break;
            case "canGoBack":
                canGoBack(methodCall, result);
                break;
            case "canGoForward":
                canGoForward(methodCall, result);
                break;
            case "goBack":
                goBack(methodCall, result);
                break;
            case "goForward":
                goForward(methodCall, result);
                break;
            case "reload":
                reload(methodCall, result);
                break;
            case "currentUrl":
                currentUrl(methodCall, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void loadUrl(MethodCall methodCall, Result result) {
        String url = (String) methodCall.arguments;
        webView.loadUrl(url);
        result.success(null);
    }

    private void canGoBack(MethodCall methodCall, Result result) {
        result.success(webView.canGoBack());
    }

    private void canGoForward(MethodCall methodCall, Result result) {
        result.success(webView.canGoForward());
    }

    private void goBack(MethodCall methodCall, Result result) {
        if (webView.canGoBack()) {
            webView.goBack();
        }
        result.success(null);
    }

    private void goForward(MethodCall methodCall, Result result) {
        if (webView.canGoForward()) {
            webView.goForward();
        }
        result.success(null);
    }

    private void reload(MethodCall methodCall, Result result) {
        webView.reload();
        result.success(null);
    }

    private void currentUrl(MethodCall methodCall, Result result) {
        result.success(webView.getUrl());
    }

    @SuppressWarnings("unchecked")
    private void updateSettings(MethodCall methodCall, Result result) {
        result.success(null);
    }

    @Override
    public void dispose() {
    }
}
