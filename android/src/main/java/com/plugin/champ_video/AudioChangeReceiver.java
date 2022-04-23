package com.plugin.champ_video;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.KeyEvent;

interface AudioEventListener {
    void onChanged();
}

public class AudioChangeReceiver extends BroadcastReceiver {

    AudioEventListener audioEventListener;

    public AudioChangeReceiver(final AudioEventListener listener) {
        this.audioEventListener = listener;
    }

    @Override
    public void onReceive(final Context context, final Intent intent) {
        if (intent.getAction().equals(Intent.ACTION_HEADSET_PLUG)) {
            audioEventListener.onChanged();
        }

    }
}