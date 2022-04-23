package com.champsoft.champ_video


import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import java.util.*


/** ChampVideoPlugin */
class ChampVideoPlugin:FlutterPlugin, MethodChannel.MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel
    private var methodChannel = "com.plugin.champsoft/champ_video"
    private lateinit var audioManager:AudioManager
    private lateinit var activeContext: Context



    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannel)
        channel.setMethodCallHandler(FlutterAudioManagerPlugin())
        val receiver = AudioChangeReceiver(listener)
        val filter = IntentFilter(Intent.ACTION_HEADSET_PLUG)
        activeContext = registrar.activeContext()
        activeContext.registerReceiver(receiver, filter)
        audioManager = activeContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager

    }

    var listener: AudioEventListener = object : AudioEventListener {
        override fun onChanged() {
            channel.invokeMethod("inputChanged", 1)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method.equals("getCurrentOutput")) {
            result.success(getCurrentOutput())
        } else if (call.method.equals("getAvailableInputs")) {
            result.success(getAvailableInputs())
        } else if (call.method.equals("changeToReceiver")) {
            result.success(changeToReceiver())
        } else if (call.method.equals("changeToSpeaker")) {
            result.success(changeToSpeaker())
        } else if (call.method.equals("changeToHeadphones")) {
            result.success(changeToHeadphones())
        } else if (call.method.equals("changeToBluetooth")) {
            result.success(changeToBluetooth())
        } else {
            result.notImplemented()
        }
    }

    private fun changeToReceiver(): Boolean {
        audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
        audioManager.stopBluetoothSco()
        audioManager.isBluetoothScoOn = false
        audioManager.isSpeakerphoneOn = false
        listener.onChanged()
        return true
    }

    private fun changeToSpeaker(): Boolean {
        audioManager.mode = AudioManager.MODE_NORMAL
        audioManager.stopBluetoothSco()
        audioManager.isBluetoothScoOn = false
        audioManager.isSpeakerphoneOn = true
        listener.onChanged()
        return true
    }

    private fun changeToHeadphones(): Boolean {
        return changeToReceiver()
    }

    private fun changeToBluetooth(): Boolean {
        audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
        audioManager.startBluetoothSco()
        audioManager.isBluetoothScoOn = true
        listener.onChanged()
        return true
    }

    private fun getCurrentOutput(): ArrayList<Any?> {
        val info: ArrayList<Any?> = ArrayList<Any?>()
        if (audioManager.isSpeakerphoneOn) {
            info.add("Speaker")
            info.add("2")
        } else if (audioManager.isBluetoothScoOn) {
            info.add("Bluetooth")
            info.add("4")
        } else if (audioManager.isWiredHeadsetOn) {
            info.add("Headset")
            info.add("3")
        } else {
            info.add("Receiver")
            info.add("1")
        }
        return info
    }

    private fun getAvailableInputs(): ArrayList<Any?>? {
        val list: ArrayList<Any?> = ArrayList<Any?>()
        list.add(Arrays.asList("Receiver", "1"))
        if (audioManager.isWiredHeadsetOn) {
            list.add(Arrays.asList("Headset", "3"))
        }
        if (audioManager.isBluetoothScoOn) {
            list.add(Arrays.asList("Bluetooth", "4"))
        }
        return list
    }

    private fun _getDeviceType(type: Int): String? {
        Log.d("type", "type: $type")
        return when (type) {
            3 -> "3"
            2 -> "2"
            1 -> "4"
            else -> "0"
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding?) {
        if (channel != null) {
            channel.setMethodCallHandler(null)
            channel = null
        }
    }
}


