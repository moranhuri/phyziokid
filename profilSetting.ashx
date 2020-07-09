s
<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using Newtonsoft.Json;
using System.Data;
using System.Data.OleDb;
using System.Collections.Generic;



public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string Name = context.Request["userName"];
        string kidName = context.Request["kidName"];
        string KidBday = context.Request["KidBday"];
        string KidStep = context.Request["KidStep"];
        string partnerEmail = context.Request["partnerEmail"];
        //string upBirthDay = Convert.ToDateTime(KidBday).ToString("MM-dd-yyyy");
        string result = context.Request["result"];



        if (Name != "" || kidName != "" || KidStep != "" || KidBday != "")
        {


            string KidID = "select KidID from ParentUsers where email=" + "'" + result + "' ";
            DataSet dataKid = sqlRet(KidID);
            string printKid = JsonConvert.SerializeObject(dataKid.Tables[0].Rows[0]["KidID"]);

            string ShowQuery = "select ParentUsers.userName, Kid.KidName, Kid.KidBday, Kid.KidStep from ParentUsers, Kid where Kid.ID=" + printKid + " AND ParentUsers.email=" + "'" + result + "' ";
            DataSet up = sqlRet(ShowQuery);
            string printResult = JsonConvert.SerializeObject(up.Tables[0].Rows[0]);

            //context.Response.Write(printResult);

            //שאילתות לעדכון משתנה בנפרד
            if (Name != "")
            {

                string updaeName = "UPDATE Kid, ParentUsers SET ParentUsers.userName ='" + Name + "' WHERE Kid.ID=" + printKid + " AND ParentUsers.email=" + "'" + result + "' ";
                DataSet NameData = sqlRet(updaeName);
                string changeDetail = JsonConvert.SerializeObject(NameData);

            }


            if (kidName != "")
            {
                string updaekidName = "UPDATE Kid, ParentUsers SET Kid.KidName= '" + kidName + "' WHERE Kid.ID=" + printKid + " AND ParentUsers.email=" + "'" + result + "' ";
                DataSet kidNameDit = sqlRet(updaekidName);
                string changeDetail2 = JsonConvert.SerializeObject(kidNameDit);
            }

            if (KidStep != "")
            {
                string updaeKidStep = "UPDATE Kid, ParentUsers SET Kid.KidStep=" + KidStep + " WHERE Kid.ID=" + printKid + " AND ParentUsers.email=" + "'" + result + "' ";
                DataSet KidStepDit = sqlRet(updaeKidStep);
                string changeDetail3 = JsonConvert.SerializeObject(KidStepDit);


            }

            if (KidBday != "")
            {
                string upBirthDay = Convert.ToDateTime(KidBday).ToString("MM-dd-yyyy");

                string updaeKidBday = "UPDATE Kid, ParentUsers SET Kid.KidBday =(DATEVALUE(#" + upBirthDay + "#))   WHERE Kid.ID=" + printKid + " AND ParentUsers.email=" + "'" + result + "' ";
                DataSet KidBdayData = sqlRet(updaeKidBday);
                string changeDetail4 = JsonConvert.SerializeObject(KidBdayData);

            }

            string AuthQuery = "select userName from ParentUsers where email=" + "'" + result + "'";
                DataSet UserNameData = sqlRet(AuthQuery);
                string UserName = JsonConvert.SerializeObject(UserNameData.Tables[0].Rows[0]["userName"]);
                UserName = UserName.Replace('"', ' ').Trim(); //מוחק את ה"" מהשם של המשתמש

             string stepValue = "select KidStep from Kid Where ID = " + printKid;
                DataSet kidSteps = sqlRet(stepValue);
                string KidStepData = JsonConvert.SerializeObject(kidSteps.Tables[0].Rows[0]["KidStep"]);

             string kidNameQuery = "select KidName from Kid where ID=" + printKid;
        DataSet dataKidName = sqlRet(kidNameQuery);
        string kidNameData = JsonConvert.SerializeObject(dataKidName.Tables[0].Rows[0]["KidName"]);
                kidNameData = kidNameData.Replace('"', ' ').Trim(); //מוחק את ה"" מהשם של המשתמש




         string kidAgeQuery = "SELECT Kid.KidBday, DateDiff('m',[Kid]![KidBday],Now()) AS Age FROM Kid Where Kid.ID = " +printKid ;
                DataSet dataKidAge = sqlRet(kidAgeQuery);
                string KidAge = JsonConvert.SerializeObject(dataKidAge.Tables[0].Rows[0]["Age"]);

                 string BdayDateQuery = "SELECT KidBday from Kid where ID=" + printKid ;
                 DataSet dataBday= sqlRet(BdayDateQuery);
                string printKidBday = JsonConvert.SerializeObject(dataBday.Tables[0].Rows[0]["KidBday"]);

        string[] dataArray = new string[] { KidStepData, kidNameData, KidAge, UserName, printKidBday};

        context.Response.Write(JsonConvert.SerializeObject(dataArray));
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










