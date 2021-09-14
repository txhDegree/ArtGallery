using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ArtGallery
{
    public class DBConnect
    {
        public static SqlConnection conn;
        public static Boolean Open()
        {
            try
            {
            string connStr = ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString;
                conn = new SqlConnection(connStr);
                conn.Open();
                return true;
            } catch (ConfigurationErrorsException ex)
            {
                return false;
            }
        }
    }
}