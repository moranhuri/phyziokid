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

        string UserEmail = context.Request["UserEmail"]; // חשוב לשים לב שזה אותו שם משתנה כמו בקובץ הJS
        string password = context.Request["password"];
        string Name = context.Request["userName"];
        string kidName = context.Request["kidName"];
        string KidBday = context.Request["KidBday"];
        string KidStep = context.Request["KidStep"];
        string partnerEmail = context.Request["partnerEmail"];
        DateTime localDate = DateTime.Now;

        if (UserEmail != "" && password != "" && Name != "" && kidName != "" && KidBday != "" && KidStep != "")
        {
            string EmailQuery = "select email from ParentUsers where email =" + "'" + UserEmail + "'";
            DataSet EmailDit = sqlRet(EmailQuery);


            if (EmailDit.Tables[0].Rows.Count == 0)
            {

                string ConvertBirthDay = Convert.ToDateTime(KidBday).ToString("MM-dd-yyyy");

                string KidQuery = "INSERT INTO Kid ( KidName, kidBday, kidStep ) VALUES ('" + kidName + "', (DATEVALUE(#" + ConvertBirthDay + "#)) ,'" + KidStep + "')";
                DataSet Dit2 = sqlRet(KidQuery);
                string response = JsonConvert.SerializeObject("פרטי הילד הוכנסו");


                string KidIDQuery = "select ID from Kid where KidName=" + "'" + kidName + "'" + "and kidBday = (DATEVALUE(#" + ConvertBirthDay + "#))";
                DataSet ID = sqlRet(KidIDQuery);
                string KID = JsonConvert.SerializeObject(ID.Tables[0].Rows[0]["ID"]);

                //הוספת משתמש
                string myQuery = "INSERT INTO ParentUsers ( email, [password], userName, KidID ) VALUES ('" + UserEmail + "'," + password + ",'" + Name + "'," + KID + ")";
                DataSet Dit = sqlRet(myQuery);


                string ConvertBirthDay2 = Convert.ToDateTime(KidBday).ToString("yyyy-MM-dd");
                DateTime bd = DateTime.Parse(ConvertBirthDay2);
                TimeSpan ts = DateTime.Now.Subtract(bd);
                DateTime age = DateTime.MinValue + ts;
                string KidAge = string.Format("", age.Month - 1);

                string[] dataArray = new string[] { KidStep, kidName, KidAge };

                context.Response.Write(JsonConvert.SerializeObject(dataArray));

                if (partnerEmail != "")
                {


                    string mainUserId = "select ID from ParentUsers where email=" + "'" + UserEmail + "'";
                    DataSet userDataId = sqlRet(mainUserId);
                    string userId = JsonConvert.SerializeObject(userDataId.Tables[0].Rows[0]["ID"]);
                    string fictivePassword = userId + "9154";
                    string partnerQuery = "INSERT INTO ParentUsers ( email, [password], userName, KidID ) VALUES ('" + partnerEmail + "'," + fictivePassword + ",'userName'," + KID + ")";
                    DataSet partnerDit = sqlRet(partnerQuery);


                    var linkPartnerConfirm = "http://projects.telem-hit.net/2020/phyziokid_ShaniMoran/partnerConfirmation.html".ToString();
                    var fromAddress = new MailAddress("phizyokid@gmail.com", "PhizyoKid");
                    var toAddress = new MailAddress(partnerEmail, Name);
                    //const string fromPassword = "phizyokid2020";
                    const string subject = "ברוכים הבאים לפיזיוקיד";
                    string body = ("הזמינו אותך להצטרף לחשבון משותף, הסיסמה שלך היא: " + fictivePassword + '\n' + "להתחברות לחץ על הקישור " + linkPartnerConfirm);

                    var smtp = new SmtpClient
                    {
                        Host = "smtp.gmail.com",
                        Port = 587,
                        EnableSsl = true,
                        DeliveryMethod = SmtpDeliveryMethod.Network,
                        Credentials = new NetworkCredential("phizyokid@gmail.com", "phizyokid2020"),
                        Timeout = 20000
                    };
                    using (var message = new MailMessage(fromAddress, toAddress)
                    {
                        Subject = subject,
                        Body = body
                    })
                    {
                        smtp.Send(message);
                    }



                }

            }

            else
            {
                context.Response.Write("כתובת האימייל שהזנת נמצאת בשימוש");
            }

        }

        else
        {
            context.Response.Write("חסרים פרטים");
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















