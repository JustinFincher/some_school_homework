package com.justzht.temperaturesystemclient;

import java.util.Calendar;
import java.util.Date;

import io.realm.RealmObject;

/**
 * Created by Fincher on 2016/10/9.
 */

public class TemperatureDataModel extends RealmObject
{
    public Date recordTime;
    public float temperature;
}