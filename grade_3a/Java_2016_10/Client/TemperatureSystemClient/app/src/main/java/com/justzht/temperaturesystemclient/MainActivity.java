package com.justzht.temperaturesystemclient;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.content.Intent;

import com.mikepenz.materialdrawer.*;
import com.mikepenz.materialdrawer.Drawer;
import com.mikepenz.materialdrawer.DrawerBuilder;
import com.mikepenz.materialdrawer.holder.BadgeStyle;
import com.mikepenz.materialdrawer.holder.StringHolder;
import com.mikepenz.materialdrawer.interfaces.OnCheckedChangeListener;
import com.mikepenz.materialdrawer.model.DividerDrawerItem;
import com.mikepenz.materialdrawer.model.ExpandableDrawerItem;
import com.mikepenz.materialdrawer.model.PrimaryDrawerItem;
import com.mikepenz.materialdrawer.model.ProfileDrawerItem;
import com.mikepenz.materialdrawer.model.ProfileSettingDrawerItem;
import com.mikepenz.materialdrawer.model.SecondaryDrawerItem;
import com.mikepenz.materialdrawer.model.SecondarySwitchDrawerItem;
import com.mikepenz.materialdrawer.model.SecondaryToggleDrawerItem;
import com.mikepenz.materialdrawer.model.SectionDrawerItem;
import com.mikepenz.materialdrawer.model.SwitchDrawerItem;
import com.mikepenz.materialdrawer.model.ToggleDrawerItem;
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

public class MainActivity extends AppCompatActivity
{
    private static final int PROFILE_SETTING = 100000;
    private Drawer result = null;
    private AccountHeader headerResult = null;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setTitle("模拟温度系统");
        setSupportActionBar(toolbar);



        final IProfile profile1 = new ProfileDrawerItem().withName("郑昊天").withEmail("justzht@gmail.com").withIcon("https://avatars1.githubusercontent.com/u/8359912?v=3&s=400").withIdentifier(1);
        final IProfile profile2 = new ProfileDrawerItem().withName("袁冠达").withEmail("731327835@qq.com").withIcon("https://avatars3.githubusercontent.com/u/10547751?v=3&s=400").withIdentifier(2);
        final IProfile profile3 = new ProfileDrawerItem().withName("张崇").withEmail("flyhighdream@qq.com").withIcon("https://avatars0.githubusercontent.com/u/9525158?v=3&s=400").withIdentifier(3);

        headerResult = new AccountHeaderBuilder()
                .withActivity(this)
                .withTranslucentStatusBar(true)
                .withHeaderBackground(R.color.primary_dark)
                .addProfiles(
                        profile1,
                        profile2,
                        profile3,
                        //don't ask but google uses 14dp for the add account icon in gmail but 20dp for the normal icons (like manage account)
                        new ProfileSettingDrawerItem().withName("添加账户").withIcon(new IconicsDrawable(this, GoogleMaterial.Icon.gmd_add).actionBar().paddingDp(5).colorRes(R.color.material_drawer_primary_text)).withIdentifier(PROFILE_SETTING),
                        new ProfileSettingDrawerItem().withName("管理账户").withIcon(GoogleMaterial.Icon.gmd_settings).withIdentifier(PROFILE_SETTING+1)
                )
                .withOnAccountHeaderListener(new AccountHeader.OnAccountHeaderListener() {
                    @Override
                    public boolean onProfileChanged(View view, IProfile profile, boolean current) {
                        //sample usage of the onProfileChanged listener
                        //if the clicked item has the identifier 1 add a new profile ;)
//                        if (profile instanceof IDrawerItem && profile.getIdentifier() == PROFILE_SETTING) {
//                            int count = 100 + headerResult.getProfiles().size() + 1;
//                            IProfile newProfile = new ProfileDrawerItem().withNameShown(true).withName("Batman" + count).withEmail("batman" + count + "@gmail.com").withIcon(R.drawable.profile5).withIdentifier(count);
//                            if (headerResult.getProfiles() != null) {
//                                //we know that there are 2 setting elements. set the new profile above them ;)
//                                headerResult.addProfile(newProfile, headerResult.getProfiles().size() - 2);
//                            } else {
//                                headerResult.addProfiles(newProfile);
//                            }
//                        }

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
                        new PrimaryDrawerItem().withName("数据采集").withIcon(GoogleMaterial.Icon.gmd_file_download).withIdentifier(1).withSelectable(false),
                        new PrimaryDrawerItem().withName("数据统计").withIcon(GoogleMaterial.Icon.gmd_assessment).withIdentifier(2).withSelectable(false),
                        new DividerDrawerItem(),
                        new PrimaryDrawerItem().withName("设置").withIcon(GoogleMaterial.Icon.gmd_settings).withIdentifier(3).withSelectable(false)
                )
                .withOnDrawerItemClickListener(new Drawer.OnDrawerItemClickListener() {
                    @Override
                    public boolean onItemClick(View view, int position, IDrawerItem drawerItem) {
                        //check if the drawerItem is set.
                        //there are different reasons for the drawerItem to be null
                        //--> click on the header
                        //--> click on the footer
                        //those items don't contain a drawerItem

                        if (drawerItem != null) {
                            Intent intent = null;
                            if (drawerItem.getIdentifier() == 1)
                            {
//                                intent = new Intent(DrawerActivity.this, CompactHeaderDrawerActivity.class);
                            } else if (drawerItem.getIdentifier() == 2)
                            {
//                                intent = new Intent(DrawerActivity.this, ActionBarActivity.class);
                            }
                            else if (drawerItem.getIdentifier() == 2)
                            {
//                                intent = new Intent(DrawerActivity.this, ActionBarActivity.class);
                            }
                            if (intent != null) {
//                                DrawerActivity.this.startActivity(intent);
                            }
                        }

                        return false;
                    }
                })
                .withSavedInstance(savedInstanceState)
                .build();

    }

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

}
