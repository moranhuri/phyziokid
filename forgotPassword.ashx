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
using System.IO;



public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string UserEmail = context.Request["UserEmail"]; // חשוב לשים לב שזה אותו שם משתנה כמו בקובץ הJS

        if (UserEmail != null)
        {

            string EmailQuery = "select email from ParentUsers where email =" + "'" + UserEmail + "'";
            DataSet EmailDit = sqlRet(EmailQuery);


            if (EmailDit.Tables[0].Rows.Count != 0)
            {
                string userQuery = "select userName, email, [password] from ParentUsers where email=" + "'" + UserEmail + "'";
                DataSet userDataForgot = sqlRet(userQuery);
                string userDetails = JsonConvert.SerializeObject(userDataForgot.Tables[0].Rows[0]);
                string userName = JsonConvert.SerializeObject(userDataForgot.Tables[0].Rows[0]["userName"]);

                userName = userName.Replace('"', ' ').Trim();

                string password = JsonConvert.SerializeObject(userDataForgot.Tables[0].Rows[0]["password"]);

                var linkForgotPassword = "http://projects.telem-hit.net/2020/phyziokid_ShaniMoran/".ToString();

                var fromAddress = new MailAddress("phizyokid@gmail.com", "PhizyoKid");
                var toAddress = new MailAddress(UserEmail, userName);
                //const string fromPassword = "phizyokid2020";
                const string subject = "שחזור סיסמה";
                string body = ("שלום " + userName + '\n' + "הסיסמה שלך היא: "+ password + '\n' + "להתחברות לחץ על הקישור "+ linkForgotPassword);
                    //להוסיף קישור לאפליקציה
                var smtp = new SmtpClient
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



                //context.Response.Write(userDetails);

            }
            else
            {

                //הוזנו פרטים לא נכונים

                string responseA = JsonConvert.SerializeObject("המשתמש לא נכון");
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



