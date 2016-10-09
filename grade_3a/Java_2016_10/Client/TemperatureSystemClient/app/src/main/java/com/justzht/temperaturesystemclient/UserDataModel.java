package com.justzht.temperaturesystemclient;

import java.util.List;

/**
 * Created by Fincher on 2016/10/9.
 */

class UserDataModel
{
    public List<User> users;
}
class User
{
    public int id;
    public String username;
    public String email;
    public String password;
    public String image;
}