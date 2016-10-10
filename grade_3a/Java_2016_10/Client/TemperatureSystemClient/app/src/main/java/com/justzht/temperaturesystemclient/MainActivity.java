package com.justzht.temperaturesystemclient;

import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.hardware.SensorEventListener;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.content.Intent;
import android.widget.FrameLayout;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import static android.content.Context.SENSOR_SERVICE;

import com.google.gson.Gson;
import com.mikepenz.materialdrawer.*;
import com.mikepenz.materialdrawer.Drawer;
import com.mikepenz.materialdrawer.DrawerBuilder;
import com.mikepenz.materialdrawer.holder.BadgeStyle;
import com.mikepenz.materialdrawer.holder.StringHolder;
import com.mikepenz.materialdrawer.interfaces.OnCheckedChangeListener;
import com.mikepenz.materialdrawer.model.DividerDrawerItem;
import com.mikepenz.materialdrawer.model.PrimaryDrawerItem;
import com.mikepenz.materialdrawer.model.ProfileDrawerItem;
import com.mikepenz.materialdrawer.model.ProfileSettingDrawerItem;
import com.mikepenz.materialdrawer.model.interfaces.IDrawerItem;
import com.mikepenz.materialdrawer.model.interfaces.IProfile;
import com.mikepenz.materialdrawer.model.interfaces.Nameable;
import com.mikepenz.materialdrawer.model.ProfileDrawerItem;
import com.mikepenz.materialdrawer.model.ProfileSettingDrawerItem;
import com.mikepenz.materialdrawer.model.interfaces.IProfile;
import com.mikepenz.itemanimators.AlphaCrossFadeAnimator;
import com.mikepenz.fontawesome_typeface_library.FontAwesome;
import com.mikepenz.google_material_typeface_library.GoogleMaterial;
import com.mikepenz.iconics.IconicsDrawable;

import java.io.IOException;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;


import java.io.Console;
import java.util.ArrayList;

public class MainActivity extends AppCompatActivity implements SensorEventListener
{

    private static final int PROFILE_SETTING = 100000;
    private Drawer result = null;
    private AccountHeader headerResult = null;

    private FrameLayout frameLayout = null;
    private Fragment dataMiningFragment = null;
    private Fragment dataStatisticsFragment = null;

    private Toolbar toolbar = null;

    private SensorManager mSensorManager;
    private Sensor mTempSensor;

    public float temperature = 100;

    OkHttpClient client = new OkHttpClient();

    public static long currentLoginUserID = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mSensorManager = (SensorManager)getSystemService(SENSOR_SERVICE);
        if (mSensorManager != null)
        {
            mTempSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ORIENTATION);
            if (mTempSensor == null)
            {
                Log.e("MainActivity","(mTempSensor == null)");
            }
        }

        toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setTitle("数据采集");
        setSupportActionBar(toolbar);

        frameLayout = (FrameLayout)findViewById(R.id.frame_layout);
        dataMiningFragment =  new DataMiningFragment();
        dataStatisticsFragment = new DataStatisticsFragment();

        FragmentManager fragMan = getFragmentManager();
        FragmentTransaction fragTransaction = fragMan.beginTransaction();
        fragTransaction.add(frameLayout.getId(), dataMiningFragment , "dataMiningFragment");
//        fragTransaction.hide(dataMiningFragment);
        fragTransaction.add(frameLayout.getId(), dataStatisticsFragment , "dataStatisticsFragment");
        fragTransaction.hide(dataStatisticsFragment);
        fragTransaction.commit();


//        final IProfile profile1 = new ProfileDrawerItem().withName("郑昊天").withEmail("justzht@gmail.com").withIcon("https://avatars1.githubusercontent.com/u/8359912?v=3&s=400").withIdentifier(1);
//        final IProfile profile2 = new ProfileDrawerItem().withName("袁冠达").withEmail("731327835@qq.com").withIcon("https://avatars3.githubusercontent.com/u/10547751?v=3&s=400").withIdentifier(2);
//        final IProfile profile3 = new ProfileDrawerItem().withName("张崇").withEmail("flyhighdream@qq.com").withIcon("https://avatars0.githubusercontent.com/u/9525158?v=3&s=400").withIdentifier(3);

        headerResult = new AccountHeaderBuilder()
                .withActivity(this)
                .withTranslucentStatusBar(true)
                .withHeaderBackground(R.color.primary_dark)
                .withOnAccountHeaderListener(new AccountHeader.OnAccountHeaderListener()
                {
                    @Override
                    public boolean onProfileChanged(View view, IProfile profile, boolean current)
                    {
                        if (profile instanceof IDrawerItem && profile.getIdentifier() == PROFILE_SETTING)
                        {
                            Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(MainApplication.networkUri+"users/new"));
                            startActivity(browserIntent);
                        }
                        else if (profile instanceof IDrawerItem && profile.getIdentifier() == PROFILE_SETTING + 1)
                        {
                            Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(MainApplication.networkUri+"users"));
                            startActivity(browserIntent);
                        }
                        else if (profile instanceof IDrawerItem && profile.getIdentifier() == PROFILE_SETTING + 2)
                        {
                            new Thread(runnable).start();
                        }else
                        {
                            // Set Current Login User
                            currentLoginUserID = profile.getIdentifier();
                            Log.d("MainActivity","Current Login User ID : "+currentLoginUserID);
                        }

                            //false if you have not consumed the event and it should close the drawer
                        return false;
                    }
                })
                .withSavedInstance(savedInstanceState)
                .build();


        result = new DrawerBuilder()
                .withActivity(this)
                .withToolbar(toolbar)
                .withHasStableIds(true)
                .withItemAnimator(new AlphaCrossFadeAnimator())
                .withAccountHeader(headerResult) //set the AccountHeader we created earlier for the header
                .addDrawerItems(
                        new PrimaryDrawerItem().withName("数据采集").withIcon(GoogleMaterial.Icon.gmd_file_download).withIdentifier(1001).withSelectable(true),
                        new PrimaryDrawerItem().withName("数据统计").withIcon(GoogleMaterial.Icon.gmd_assessment).withIdentifier(1002).withSelectable(true),
                        new DividerDrawerItem(),
                        new PrimaryDrawerItem().withName("设置").withIcon(GoogleMaterial.Icon.gmd_settings).withIdentifier(1003).withSelectable(true)
                )
                .withOnDrawerItemClickListener(new Drawer.OnDrawerItemClickListener() {
                    @Override
                    public boolean onItemClick(View view, int position, IDrawerItem drawerItem) {
                        //check if the drawerItem is set.
                        //there are different reasons for the drawerItem to be null
                        //--> click on the header
                        //--> click on the footer
                        //those items don't contain a drawerItem

                        if (drawerItem != null)
                        {
                            FragmentManager fragmentManager = getFragmentManager();
                            FragmentTransaction ft = fragmentManager.beginTransaction();
                            if (drawerItem.getIdentifier() == 1001)
                            {
                                ft.hide(dataStatisticsFragment);
                                ft.show(dataMiningFragment);
                                toolbar.setTitle("数据采集");
                            } else if (drawerItem.getIdentifier() == 1002)
                            {
                                ft.hide(dataMiningFragment);
                                ft.show(dataStatisticsFragment);
                                toolbar.setTitle("数据统计");
                            }
                            else if (drawerItem.getIdentifier() == 1003)
                            {
//                                intent = new Intent(DrawerActivity.this, ActionBarActivity.class);
                            }
                            ft.commit();
                        }

                        return false;
                    }
                })
                .withSavedInstance(savedInstanceState)
                .build();

        new Thread(runnable).start();

    }


    Runnable runnable = new Runnable()
    {
        @Override
        public void run()
        {
            runOnUiThread(new Runnable() {
                @Override
                public void run()
                {
                    headerResult.clear();
                    headerResult.addProfiles(
                            new ProfileSettingDrawerItem().withName("添加账户").withIcon(GoogleMaterial.Icon.gmd_add).withIdentifier(PROFILE_SETTING),
                            new ProfileSettingDrawerItem().withName("管理账户").withIcon(GoogleMaterial.Icon.gmd_settings).withIdentifier(PROFILE_SETTING+1),
                            new ProfileSettingDrawerItem().withName("刷新账户").withIcon(GoogleMaterial.Icon.gmd_refresh).withIdentifier(PROFILE_SETTING+2)
                    );
                }
            });
            Log.d("TAG","Runnable");
            Request request = new Request.Builder()
                    .url(MainApplication.networkUri+"users.json")
                    .build();
            try
            {
                Response response = client.newCall(request).execute();

                Gson gson = new Gson();
                User[] userData = gson.fromJson(response.body().string(),User[].class);
                for (int i = 0; i < userData.length; i++)
                {
                    User user = userData[i];
                    final IProfile profile = new ProfileDrawerItem().withName(user.username).withEmail(user.email).withIcon(user.image).withIdentifier(user.id);

                    runOnUiThread(new Runnable() {
                        @Override
                        public void run()
                        {
                            if (headerResult.getProfiles() != null)
                            {
                                //we know that there are 2 setting elements. set the new profile above them ;)
                                headerResult.addProfile(profile, headerResult.getProfiles().size() - 3);
                            } else {
                                headerResult.addProfiles(profile);
                            }
                        }
                    });

                }

            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    };

    @Override
    public void onBackPressed() {
        //handle the back press :D close the drawer first and if the drawer is closed close the activity
        if (result != null && result.isDrawerOpen()) {
            result.closeDrawer();
        } else {
            super.onBackPressed();
        }
    }

    @Override
    protected void onSaveInstanceState(Bundle outState)
    {
        //add the values which need to be saved from the drawer to the bundle
        outState = result.saveInstanceState(outState);
        //add the values which need to be saved from the accountHeader to the bundle
        outState = headerResult.saveInstanceState(outState);
        super.onSaveInstanceState(outState);
    }

    protected void onResume() {
        Log.d("MainActivity","onResume");
        super.onResume();
        mSensorManager.registerListener(this, mTempSensor, SensorManager.SENSOR_DELAY_NORMAL);
    }

    protected void onPause() {
        super.onPause();
        mSensorManager.unregisterListener(this,mTempSensor);
        Log.d("MainActivity","onPause");
    }

    public void onAccuracyChanged(Sensor sensor, int accuracy)
    {

    }

    public void onSensorChanged(SensorEvent event)
    {
        temperature = (event.values[1]  + 100)/2;
    }

    public float getTemperature()
    {
        return temperature;
    }

}
