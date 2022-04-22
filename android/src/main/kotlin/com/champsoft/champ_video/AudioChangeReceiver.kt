package com.champsoft.champ_video

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

interface AudioEventListener {
    fun onChanged()
}

class AudioChangeReceiver(var audioEventListener: AudioEventListener) : BroadcastReceiver() {
    @Override
    fun onReceive(context: Context?, intent: Intent) {
        if (intent.getAction().equals(Intent.ACTION_HEADSET_PLUG)) {
//            final int state = intent.getIntExtra("state", -1);
            audioEventListener.onChanged()
        }
        //        else if(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED.equals(intent.getAction())){
//            audioEventListener.onChanged();
//        }else if(BluetoothAdapter.ACTION_STATE_CHANGED.equals(intent.getAction())){
//            audioEventListener.onChanged();
//        }
    }
}