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
        string UserEmail = context.Request["UserEmail"];
        string partnerPassword = context.Request["password"];
        string newPassword = context.Request["newPassword"];
        //string result = context.Request["result"];


        if (Name != "" || UserEmail != "" || partnerPassword != "")
        {
            string oldPasswordQuery = "select password from ParentUsers where email=" + "'" + UserEmail + "'";
            DataSet userDataPass = sqlRet(oldPasswordQuery);
            string ficPass = JsonConvert.SerializeObject(userDataPass.Tables[0].Rows[0]["password"]);
           

                //בדיקה אם קיים משתמש 
            if (userDataPass.Tables[0].Rows.Count != 0) { 
            // בדיקה אם הסיסמה הזמנית נכונה 
            if (partnerPassword == ficPass)
            {
                string updaePartnerQuery = "UPDATE ParentUsers SET userName ='" + Name + "', [password] = " + newPassword + " WHERE email='" + UserEmail + "' ";
                DataSet updatePartner = sqlRet(updaePartnerQuery);
                string changeDetailPartner = JsonConvert.SerializeObject(updatePartner);

                string KidValue = "select KidID from ParentUsers where email=" + "'" + UserEmail + "'";
                DataSet kidData = sqlRet(KidValue);
                string kidID = JsonConvert.SerializeObject(kidData.Tables[0].Rows[0]["KidID"]);

                string stepValue = "select KidStep from Kid Where ID = " + kidID;
                DataSet kidSteps = sqlRet(stepValue);
                string kidStep = JsonConvert.SerializeObject(kidSteps.Tables[0].Rows[0]["KidStep"]);

                context.Response.Write(kidStep);
            }

              else
            {
                context.Response.Write("הפרטים שהזנת לא נכונים");
            }
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
















////האם המשחק קיים
//if (EmailDit.Tables[0].Rows.Count != 0)
//{

//    ////האם המשחק מפורסם
//    //if (EmailDit.Tables[0].Rows[0]["KidName"] != null)
//    //{

//    //    //יצירת הjson עם פרטי המשחק
//    //    // string jsonGameText = "{ \"KidName\": \"" + EmailDit.Tables[0].Rows[0]["KidName"].ToString() + "\", ";

//    //    //קבלת כל הפריטים של המשחק הרלוונטי
//    //    string AuthQuery = "select * from ParentUsers where KidID = " + EmailDit.Tables[0].Rows[0]["ID"];
//    //    DataSet UserName = sqlRet(AuthQuery);

//    //    //הוספה של הפריטים לJson
//    //    // jsonGameText += "\"questions\": " + JsonConvert.SerializeObject(UserName.Tables[0]) + "}";

//    //    context.Response.Write(jsonGameText);
//    //}
//    //else
//    //{
//    //    //במידה ולא מפורסם
//    //    context.Response.Write("היוזר לא קיים");
//    //}
//}
//else
//{
//    //במידה והמשחק לא קיים
//    context.Response.Write("לא קיימים משתמשים");
//}