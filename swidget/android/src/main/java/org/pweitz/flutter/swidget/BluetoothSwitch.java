package org.pweitz.flutter.swidget;


import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.content.Intent;

public class BluetoothSwitch {

    private static final BluetoothSwitch instance = new BluetoothSwitch();
    private static final int REQUEST_ENABLE_BT = 0x2;

    private BluetoothSwitch() {

    }

    public static BluetoothSwitch getInstance() {
        return instance;
    }

    public boolean displayBluetoothSettingsRequest(Activity activity) {
        BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if(mBluetoothAdapter == null) {
            return false;
        }

        if (!mBluetoothAdapter.isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            activity.startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
        }
        return true;
    }
}
