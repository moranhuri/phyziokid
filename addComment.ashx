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

        string comment = context.Request["comment"]; // חשוב לשים לב שזה אותו שם משתנה כמו בקובץ הJS
        string postDate = context.Request["postDate"];
        string emailUser = context.Request["emailUser"];
      string ConvertBirthDay = Convert.ToDateTime(postDate).ToString("dd-MM-yyyy");

        string KidID = "select KidID from ParentUsers where email=" + "'" + emailUser + "' ";
        DataSet dataKid = sqlRet(KidID);
        string printKid = JsonConvert.SerializeObject(dataKid.Tables[0].Rows[0]["KidID"]);

        string writerID = "select writerID from newPost where KidID=" + printKid + " GROUP BY writerID";
        DataSet dataWriter = sqlRet(writerID);



        if (comment != "" && postDate != "")

        {

            string ParentsID = "select ID from ParentUsers where email=" + "'" + emailUser + "' ";
            DataSet dataParents = sqlRet(ParentsID);
            string printParentsID = JsonConvert.SerializeObject(dataParents.Tables[0].Rows[0]["ID"]);

            string userNameQuery = "select userName from ParentUsers where email=" + "'" + emailUser + "' ";
            DataSet dataUserName = sqlRet(userNameQuery);
            string printUserName = JsonConvert.SerializeObject(dataUserName.Tables[0].Rows[0]["userName"]);

            printUserName = printUserName.Replace('"', ' ').Trim(); //מוחק את ה"" מהשם של המשתמש

            string newPost = "INSERT INTO newPost ([dateTime], comment, [KidID], [writerID], userName) VALUES ((DATEVALUE(#" + ConvertBirthDay + "#)) ,'" + comment + "', " + printKid + ", " + printParentsID + ", '" + printUserName + "')";
            DataSet postData = sqlRet(newPost);
            string newPostText = JsonConvert.SerializeObject(postData);


        }


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





