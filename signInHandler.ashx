s
<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using Newtonsoft.Json;
using System.Data;
using System.Data.OleDb;
using System.Collections.Generic;
using System.Globalization;


public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string UserEmail = context.Request["UserEmail"]; // חשוב לשים לב שזה אותו שם משתנה כמו בקובץ הJS
        string password = context.Request["password"];
        DateTime localDate = DateTime.Now;

        if (UserEmail != null || password != null  )
        {

            string EmailQuery = "select email from ParentUsers where email =" + "'" + UserEmail + "' and password =" + password  ;

            DataSet EmailDit = sqlRet(EmailQuery);


            if (EmailDit.Tables[0].Rows.Count != 0)
            {
                string AuthQuery = "select userName from ParentUsers where email=" + "'" + UserEmail + "'" + "and password = " + password;
                DataSet UserNameData = sqlRet(AuthQuery);
                string UserName = JsonConvert.SerializeObject(UserNameData.Tables[0].Rows[0]["userName"]);

                string KidValue = "select KidID from ParentUsers where email=" + "'" + UserEmail + "'" + "and password = " + password;
                DataSet kidData = sqlRet(KidValue);
                string kidID = JsonConvert.SerializeObject(kidData.Tables[0].Rows[0]["KidID"]);

                string stepValue = "select KidStep from Kid Where ID = " + kidID;
                DataSet kidSteps = sqlRet(stepValue);
                string kidStep = JsonConvert.SerializeObject(kidSteps.Tables[0].Rows[0]["KidStep"]);

                string kidNameQuery = "select KidName from Kid where ID=" + kidID ;
                DataSet dataKidName = sqlRet(kidNameQuery);
                string printKidName = JsonConvert.SerializeObject(dataKidName.Tables[0].Rows[0]["KidName"]);



                string kidAgeQuery = "SELECT Kid.KidBday, DateDiff('m',[Kid]![KidBday],Now()) AS Age FROM Kid Where Kid.ID = " +kidID ;
                DataSet dataKidAge = sqlRet(kidAgeQuery);
                string printKidAge = JsonConvert.SerializeObject(dataKidAge.Tables[0].Rows[0]["Age"]);

                string BdayDateQuery = "SELECT KidBday from Kid where ID=" + kidID ;
                 DataSet dataBday= sqlRet(BdayDateQuery);
                string printKidBday = JsonConvert.SerializeObject(dataBday.Tables[0].Rows[0]["KidBday"]);

                string[] dataArray = new string[] { kidStep, printKidName, printKidAge ,UserName, printKidBday };

                context.Response.Write(JsonConvert.SerializeObject(dataArray));

            }
            else
            {

                //הוזנו פרטים לא נכונים

                string responseA = JsonConvert.SerializeObject("הוזנו פרטים לא נכונים");

                context.Response.Write(responseA);

            }

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



