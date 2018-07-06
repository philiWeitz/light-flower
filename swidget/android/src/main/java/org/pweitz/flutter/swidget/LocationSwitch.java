package org.pweitz.flutter.swidget;

import android.app.Activity;
import android.content.Context;
import android.content.IntentSender;
import android.location.LocationManager;
import android.util.Log;

import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResult;
import com.google.android.gms.location.LocationSettingsStatusCodes;


public class LocationSwitch {

    private static final String TAG = "LocationSwitch";
    protected static final int REQUEST_CHECK_SETTINGS = 0x1;

    private static final LocationSwitch instance = new LocationSwitch();

    private int mInterval = 1000;
    private int mAccuracy = LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY;

    private LocationSwitch() {

    }


    public static LocationSwitch getInstance() {
        return instance;
    }


    public void displayLocationSettingsRequest(final Activity activity) {
        LocationManager lm =
                (LocationManager)activity.getSystemService(Context.LOCATION_SERVICE);

        if (lm.isProviderEnabled(LocationManager.GPS_PROVIDER) ||
                lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
            return;
        }

        GoogleApiClient googleApiClient = new GoogleApiClient.Builder(activity)
                .addApi(LocationServices.API).build();
        googleApiClient.connect();

        LocationRequest locationRequest = LocationRequest.create();
        locationRequest.setPriority(mAccuracy);
        locationRequest.setInterval(mInterval);
        locationRequest.setFastestInterval(mInterval / 2);

        LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder()
                .addLocationRequest(locationRequest);
        builder.setAlwaysShow(false);

        final PendingResult<LocationSettingsResult> result =
                LocationServices.SettingsApi.checkLocationSettings(googleApiClient, builder.build());
        result.setResultCallback(new LocationResultCallback(activity));
    }


    public void onActivityResult(int requestCode, int resultCode) {
        switch (requestCode) {
            case REQUEST_CHECK_SETTINGS:
                switch (resultCode) {
                    case Activity.RESULT_OK:
                        break;
                    case Activity.RESULT_CANCELED:
                        break;
                }
                break;
        }
    }


    private class LocationResultCallback implements ResultCallback<LocationSettingsResult> {

        private Activity mActivity;

        public LocationResultCallback(Activity activity) {
            mActivity = activity;
        }

        @Override
        public void onResult(LocationSettingsResult result) {
            final Status status = result.getStatus();
            switch (status.getStatusCode()) {
                case LocationSettingsStatusCodes.SUCCESS:
                    // All location settings are satisfied -> nothing to do
                    break;
                case LocationSettingsStatusCodes.RESOLUTION_REQUIRED:
                    // Location settings are not satisfied. Show the user a dialog to upgrade location settings
                    try {
                        // Show the dialog by calling startResolutionForResult(), and check the result
                        status.startResolutionForResult(mActivity, REQUEST_CHECK_SETTINGS);
                    } catch (IntentSender.SendIntentException e) {
                        Log.e(TAG, "PendingIntent unable to execute request.", e);
                    }
                    break;
                case LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE:
                    Log.e(TAG, "Location settings are inadequate, and cannot be fixed here. Dialog not created.");
                    break;
            }
        }
    }
}
