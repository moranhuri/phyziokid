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

public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        context.Response.ContentType = "text/plain";

        string emailUser = context.Request["emailUser"];


        string KidID = "select KidID from ParentUsers where email=" + "'" + emailUser + "' ";
        DataSet dataKid = sqlRet(KidID);
        string printKid = JsonConvert.SerializeObject(dataKid.Tables[0].Rows[0]["KidID"]);

        string writerID = "select writerID from newPost where KidID=" + printKid + " GROUP BY writerID";
        DataSet dataWriter = sqlRet(writerID);


        if (dataWriter.Tables[0].Rows.Count != 0){
            string printWriterID1 = JsonConvert.SerializeObject(dataWriter.Tables[0].Rows[0]["writerID"]);


            if (dataWriter.Tables[0].Rows.Count <2)
            {


                string allPosts = "select comment, userName, dateTime  from newPost  where  writerID =" + printWriterID1;
                DataSet dataPosts = sqlRet(allPosts);
                string postsFromData = JsonConvert.SerializeObject(dataPosts);



                context.Response.Write(postsFromData);

            }
            else
            {
                string printWriterID2 = JsonConvert.SerializeObject(dataWriter.Tables[0].Rows[1]["writerID"]);
                string allPosts = "select comment, userName, dateTime from newPost  where  writerID =" + printWriterID1 + " OR writerID =" + printWriterID2;
                DataSet dataPosts = sqlRet(allPosts);
                string postsFromData = JsonConvert.SerializeObject(dataPosts);

                context.Response.Write(postsFromData);
            }



        }
        //שם הילד- אביבה
        //string kidNameQuery = "select KidName from Kid where ID=" + printKid ;
        //DataSet dataKidName = sqlRet(kidNameQuery);
        //string printKidName = JsonConvert.SerializeObject(dataKidName.Tables[0].Rows[0]["KidName"]);
        // context.Response.Write(printKidName);


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





