s
<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using Newtonsoft.Json;
using System.Data;
using System.Data.OleDb;
using System.Collections.Generic;
using System.Net.Mail;
using System.Net;
using System.Globalization;

public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        context.Response.ContentType = "text/plain";

        string postID = context.Request["postID"]; // חשוב לשים לב שזה אותו שם משתנה כמו בקובץ הJS


        string deleteQurey = "delete * from newPost where ID=" + "'" + postID + "' ";
        DataSet deletePost = sqlRet(deleteQurey);
        string printKid = JsonConvert.SerializeObject(deletePost);


    }





    public DataSet sqlRet(string AuthQuery)
    {
        string mySource = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + HttpContext.Current.Server.MapPath("App_Data/phyzioKid_DB.accdb") + ";";

        OleDbDataAdapter oda = new OleDbDataAdapter(AuthQuery, mySource);
        DataSet ds = new DataSet();
        oda.Fill(ds);
        return ds;
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}





