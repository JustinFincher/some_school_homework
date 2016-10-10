package com.justzht.temperaturesystemclient;

import android.app.DatePickerDialog;
import android.app.Fragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;

import com.github.mikephil.charting.charts.LineChart;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;

import java.io.IOException;
import java.util.List;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.google.gson.Gson;

/**
 * Created by Fincher on 2016/10/9.
 */

public class DataStatisticsFragment extends Fragment
{
    private Button beginTimeButton = null;
    private Button endTimeButton = null;

    private Date beginDate = new Date();
    private Date endDate = new Date();
    private LineChart chart = null;

    OkHttpClient client = new OkHttpClient();


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        View view = inflater.inflate(R.layout.data_statistics_fragment,
                container, false);

        chart = (LineChart) view.findViewById(R.id.temperature_chart);
        beginTimeButton = (Button) view.findViewById(R.id.begin_time_button);
        endTimeButton = (Button) view.findViewById(R.id.end_time_button);

        setButtonOnClick(beginTimeButton);
        setButtonOnClick(endTimeButton);

        return view;
//        return inflater.inflate(R.layout.data_statistics_fragment, container, false);
    }

    public void setButtonOnClick(final Button btn)
    {
        btn.setOnClickListener(new View.OnClickListener()
        {
            public void onClick(View v)
            {
                // Perform action on click
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                String currentDate = btn.getText().toString();
                Date d = null;
                try {
                    d = dateFormat.parse(currentDate);
                } catch (ParseException e)
                {
                    d = new Date(System.currentTimeMillis());
                    e.printStackTrace();
                }

                Log.d("DataStatisticsFragment",d.toString());
                long timeInMillis = d.getTime();
                Calendar calendar = Calendar.getInstance();
                calendar.setTimeInMillis (timeInMillis);
                int year = calendar.get(Calendar.YEAR);
                int month = calendar.get(Calendar.MONTH);
                int day = calendar.get(Calendar.DAY_OF_MONTH);

                // Perform action on click
                DatePickerDialog dialog = new DatePickerDialog(v.getContext(), new DatePickerDialog.OnDateSetListener()
                {
                    @Override
                    public void onDateSet(DatePicker datePicker, int i, int i1, int i2)
                    {
                        Calendar calendar = Calendar.getInstance();
                        calendar.set(i, i1, i2);
                        if (btn == beginTimeButton)
                        {
                            beginDate.setTime(calendar.getTimeInMillis());
                        }else if (btn == endTimeButton)
                        {
                            endDate.setTime(calendar.getTimeInMillis());
                        }

                        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                        String strDate = format.format(calendar.getTime());
                        btn.setText(strDate);
                        new Thread(webTaskRunable).start();
                    }
                }, year,month,day);
                dialog.show();
            }
        });
    }

    Runnable webTaskRunable = new Runnable()
    {
        @Override
        public void run()
        {
            String body = null;
            Request request = new Request.Builder()
                    .url(MainApplication.networkUri + "users/" + MainActivity.currentLoginUserID + "/records.json")
                    .build();
            try
            {
                Response response = client.newCall(request).execute();
//                Log.d("DataStatisticsFragment",response.body().string());
                if (response.body() != null)
                {
                    body = response.body().string();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            if(body != null)
            {
                Gson gson = new Gson();
                Log.d("DataStatisticsFragment",body);
                Record[] recordData = gson.fromJson(body,Record[].class);

                List<Entry> entries = new ArrayList<Entry>();
                for (Record data : recordData)
                {
                    if (data.datetime.getTime() > beginDate.getTime() && data.datetime.getTime() < endDate.getTime())
                        entries.add(new Entry(data.datetime.getTime(), data.temperature));
                }
                LineDataSet dataSet = new LineDataSet(entries, "Label");
                final LineData lineData = new LineData(dataSet);

                getActivity().runOnUiThread(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        chart.setData(lineData);
                        chart.invalidate(); // refresh
                    }
                });
            }

        }
    };


}