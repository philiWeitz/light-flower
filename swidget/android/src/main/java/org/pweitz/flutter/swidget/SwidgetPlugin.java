package org.pweitz.flutter.swidget;

import android.app.Activity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** SwidgetPlugin */
public class SwidgetPlugin implements MethodCallHandler {

  private final Activity activity;


  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "swidget");
    channel.setMethodCallHandler(new SwidgetPlugin(registrar.activity()));
  }


  private SwidgetPlugin(Activity activity) {
    this.activity = activity;
  }


  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);

    } else if (call.method.equals("activateLocationService")) {
      LocationSwitch.getInstance().displayLocationSettingsRequest(activity);
      result.success("shown");

    } else if (call.method.equals("activateBluetoothService")) {
      BluetoothSwitch.getInstance().displayBluetoothSettingsRequest(activity);
      result.success("shown");

    } else {
      result.notImplemented();
    }
  }
}
