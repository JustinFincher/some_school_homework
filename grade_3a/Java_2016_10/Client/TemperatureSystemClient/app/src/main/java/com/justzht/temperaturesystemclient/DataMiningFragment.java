package com.justzht.temperaturesystemclient;

import android.app.Fragment;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import static android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
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
    private TimerTask timerTask;

    @Override
    public void onResume()
    {
        super.onResume();
        textView = (TextView)getView().findViewById(R.id.temperature_text);
        if(timer != null) {
            return;
        }
        timerTask = new TimerTask()
        {
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
        timer = new Timer();
        timer.scheduleAtFixedRate(timerTask, 0, 200);
    }

    @Override
    public void onPause()
    {
        super.onPause();
        timer.cancel();
        timer = null;
        timerTask.cancel();
        timerTask = null;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        View view = inflater.inflate(R.layout.data_mining_fragment,
                container, false);

        FloatingActionButton button = (FloatingActionButton) view.findViewById(R.id.floatingActionButton);
        button.setOnClickListener(new OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                Log.d("DataMiningFragment","Button Clicked");
            }
        });
        return view;
//        return inflater.inflate(R.layout.data_mining_fragment, container, false);
    }
}
