package com.example.flutter_memory;

import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterJNI;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String BATTERY_CHANNEL = "samples.flutter.io/battery";

    @Override
    public void configureFlutterEngine( FlutterEngine flutterEngine) {
//        new MethodChannel(flutterEngine.getDartExecutor(), BATTERY_CHANNEL).setMethodCallHandler(
//                (call, result) -> {
//                    if (call.method.equals("getUri")) {
//                        result.success(FlutterJNI.getObservatoryUri());
//                    } else {
//                        result.notImplemented();
//                    }
//                }
//        );
    }


}
