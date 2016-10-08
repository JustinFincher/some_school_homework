package com.justzht.temperaturesystemclient;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by Fincher on 2016/10/9.
 */

public class DataMiningFragment extends Fragment
{

    private TextView textView = null;
    private Timer timer;
    private TimerTask timerTask = new TimerTask() {
        @Override
        public void run()
        {
            if (getActivity() != null)
            {
                final MainActivity act = (MainActivity)getActivity();
                act.runOnUiThread(new Runnable() {
                    public void run()
                    {
//                        Toast.makeText(act,Float.toString(act.getTemperature()) + " °C",Toast.LENGTH_SHORT).show();
                        textView.setText(Float.toString(act.getTemperature()) + "°C");
                    }
                });
            }
        }
    };

    @Override
    public void onStart()
    {
        super.onStart();
        textView = (TextView)getView().findViewById(R.id.temperature_text);
        if(timer != null) {
            return;
        }
        timer = new Timer();
        timer.scheduleAtFixedRate(timerTask, 0, 200);
    }

    @Override
    public void onStop()
    {
        super.onStop();
        timer.cancel();
        timer = null;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        return inflater.inflate(R.layout.data_mining_fragment, container, false);
    }
}
