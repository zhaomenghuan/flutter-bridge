package cn.com.agree.flutterbridge;

import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterBridgePlugin
 */
public class FlutterBridgePlugin {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        registrar
                .platformViewRegistry()
                .registerViewFactory(
                        "plugins.flutter.io/webview", new WebViewFactory(registrar.messenger()));
    }
}