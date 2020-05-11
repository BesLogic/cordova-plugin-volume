package cordova.plugin.volume;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.LOG;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.media.*;

/**
 * This class echoes a string called from JavaScript.
 */
public class VolumeManager extends CordovaPlugin {

    public static final String SET = "setVolume";
	public static final String GET = "getVolume";
    private static final String TAG = "VolumeManager";

    private Context context;
	private AudioManager manager;

    @Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
		boolean actionState = true;
		context = cordova.getActivity().getApplicationContext();
		manager = (AudioManager)context.getSystemService(Context.AUDIO_SERVICE);
		if (SET.equals(action)) {
			try {
				//Get the volume value to set
				int volumeToSet = (int) Math.round(args.getDouble(0) * 100.0f);
				int volume = getVolumeToSet(volumeToSet);
				boolean play_sound;

				if (args.length() > 1 && !args.isNull(1)) {
					play_sound = args.getBoolean(1);
				} else {
					play_sound = true;
				}

				//Set the volume
				manager.setStreamVolume(AudioManager.STREAM_MUSIC, volume, (play_sound ? AudioManager.FLAG_PLAY_SOUND : 0));
				callbackContext.success();
			} catch (Exception e) {
				LOG.d(TAG, "Error setting volume " + e);
				actionState = false;
			}
		} else if(GET.equals(action)) {
			try {
				//Get current system volume
				int _currVol = getCurrentVolume();
				float currVol = _currVol / 100.0f;
				String strVol= String.valueOf(currVol);
				callbackContext.success(strVol);
			} catch (Exception e) {
				LOG.d(TAG, "Error setting volume " + e);
				actionState = false;
			}
		} else {
			actionState = false;
		}
		return actionState;
	}

	private int getVolumeToSet(int percent) {
		try {
			int volLevel;
			int maxVolume = manager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
			volLevel = Math.round((percent * maxVolume) / 100);

			return volLevel;
		} catch (Exception e){
			LOG.d(TAG, "Error getting VolumeToSet: " + e);
			return 1;
		}
	}

	private int getCurrentVolume() {
		try {
			int volLevel;
			int maxVolume = manager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
			int currSystemVol = manager.getStreamVolume(AudioManager.STREAM_MUSIC);
			volLevel = Math.round((currSystemVol * 100) / maxVolume);

			return volLevel;
		} catch (Exception e) {
			LOG.d(TAG, "Error getting CurrentVolume: " + e);
			return 1;
		}
	}
}
