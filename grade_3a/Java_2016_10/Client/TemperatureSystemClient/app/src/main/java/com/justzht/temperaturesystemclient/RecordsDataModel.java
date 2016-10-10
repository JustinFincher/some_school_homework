package com.justzht.temperaturesystemclient;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Created by Fincher on 2016/10/10.
 */

class RecordsDataModel
{
    public List<Record> records;
}
class Record
{
    public int id;
    public float temperature;
    public Date datetime;
    public int user_id;
}