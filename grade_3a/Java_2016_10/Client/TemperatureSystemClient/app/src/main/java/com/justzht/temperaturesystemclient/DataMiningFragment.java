package com.justzht.temperaturesystemclient;

import android.app.Fragment;
import android.content.Context;
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

import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * Created by Fincher on 2016/10/9.
 */

public class DataMiningFragment extends Fragment
{
    public static final MediaType JSON
            = MediaType.parse("application/json; charset=utf-8");
    OkHttpClient client = new OkHttpClient();

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
                new Thread(webTaskRunable).start();
            }
        });
        return view;
    }

    Runnable webTaskRunable = new Runnable()
    {
        @Override
        public void run()
        {
            final MainActivity act = (MainActivity)getActivity();
            RequestBody body = RequestBody.create(JSON,"{\"user_id\":"+MainActivity.currentLoginUserID+",\"temperature\":"+act.getTemperature()+"}");
            Request request = new Request.Builder()
                    .url(MainApplication.networkUri+"records.json")
                    .post(body)
                    .build();
            try
            {
                Response response = client.newCall(request).execute();
                final String result = response.body().string();
                act.runOnUiThread(new Runnable()
                {
                    public void run()
                    {
                        Context context = getActivity().getApplicationContext();
                        int duration = Toast.LENGTH_SHORT;
                        Toast toast = Toast.makeText(context, result, duration);
                        toast.show();
                    }
                });
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
        }
    };
}
