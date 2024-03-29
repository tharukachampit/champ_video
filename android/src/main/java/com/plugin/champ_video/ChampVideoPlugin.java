package com.plugin.champ_video;

import androidx.annotation.NonNull;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.media.MediaRouter;
import android.content.Context;
import android.os.Build;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** ChampVideoPlugin */
public class ChampVideoPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native
  /// Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine
  /// and unregister it
  /// when the Flutter Engine is detached from the Activity
  private static MethodChannel channel;
  private static AudioManager audioManager;
  private static Context activeContext;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.plugin.champsoft/champ_video");
    channel.setMethodCallHandler(this);
    AudioChangeReceiver receiver = new AudioChangeReceiver(listener);
    IntentFilter filter = new IntentFilter(Intent.ACTION_HEADSET_PLUG);
    activeContext = flutterPluginBinding.getApplicationContext();
    activeContext.registerReceiver(receiver, filter);
    audioManager = (AudioManager) activeContext.getSystemService(Context.AUDIO_SERVICE);
  }

  static AudioEventListener listener = new AudioEventListener() {
    @Override
    public void onChanged() {
      channel.invokeMethod("inputChanged", 1);
    }
  };

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getCurrentOutput")) {
      result.success(getCurrentOutput());
    } else if (call.method.equals("getAvailableInputs")) {
      result.success(getAvailableInputs());
    } else if (call.method.equals("changeToReceiver")) {
      result.success(changeToReceiver());
    } else if (call.method.equals("changeToSpeaker")) {
      result.success(changeToSpeaker());
    } else if (call.method.equals("changeToHeadphones")) {
      result.success(changeToHeadphones());
    } else if (call.method.equals("changeToBluetooth")) {
      result.success(changeToBluetooth());
    } else {
      result.notImplemented();
    }
  }

  private boolean changeToReceiver() {
    audioManager.setMode(AudioManager.MODE_IN_COMMUNICATION);
    audioManager.stopBluetoothSco();
    audioManager.setBluetoothScoOn(false);
    audioManager.setSpeakerphoneOn(false);
    listener.onChanged();
    return true;
  }

  private boolean changeToSpeaker() {
    audioManager.setMode(AudioManager.MODE_NORMAL);
    audioManager.stopBluetoothSco();
    audioManager.setBluetoothScoOn(false);
    audioManager.setSpeakerphoneOn(true);
    listener.onChanged();
    return true;
  }

  private boolean changeToHeadphones() {
    return changeToReceiver();
  }

  private boolean changeToBluetooth() {
    audioManager.setMode(AudioManager.MODE_IN_COMMUNICATION);
    audioManager.startBluetoothSco();
    audioManager.setBluetoothScoOn(true);
    listener.onChanged();
    return true;
  }

  private List<String> getCurrentOutput() {
    List<String> info = new ArrayList();
    if (audioManager.isSpeakerphoneOn()) {
      info.add("Speaker");
      info.add("2");
    } else if (audioManager.isBluetoothScoOn()) {
      info.add("Bluetooth");
      info.add("4");
    } else if (audioManager.isWiredHeadsetOn()) {
      info.add("Headset");
      info.add("3");
    } else {
      info.add("Receiver");
      info.add("1");
    }
    return info;
  }

  private List<List<String>> getAvailableInputs() {
    List<List<String>> list = new ArrayList();
    list.add(Arrays.asList("Receiver", "1"));
    if (audioManager.isWiredHeadsetOn()) {
      list.add(Arrays.asList("Headset", "3"));
    }
    if (audioManager.isBluetoothScoOn()) {
      list.add(Arrays.asList("Bluetooth", "4"));
    }
    return list;
  }

  private String _getDeviceType(int type) {
    Log.d("type", "type: " + type);
    switch (type) {
      case 3:
        return "3";
      case 2:
        return "2";
      case 1:
        return "4";
      default:
        return "0";
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (channel != null) {
      channel.setMethodCallHandler(null);
      channel = null;
    }
  }
}
