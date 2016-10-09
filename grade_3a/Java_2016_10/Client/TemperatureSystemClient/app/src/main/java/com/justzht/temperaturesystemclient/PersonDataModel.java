package com.justzht.temperaturesystemclient;

import io.realm.RealmList;
import io.realm.RealmObject;

/**
 * Created by Fincher on 2016/10/9.
 */

public class PersonDataModel extends RealmObject
{
    public RealmList<TemperatureDataModel> temperatureDataModelRealmList;
    public String userName;
    public String mail;
    public String password;
}
