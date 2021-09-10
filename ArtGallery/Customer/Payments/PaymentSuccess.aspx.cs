using ArtGallery.Email;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArtGallery.Customer.Payments
{
    public partial class PaymentSuccess : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("UPDATE Payments SET status = 'paid', UpdatedAt = @Now WHERE Id = @Id", conn);
            cmd.Parameters.AddWithValue("@Now", DateTime.Now);
            cmd.Parameters.AddWithValue("@Id", Request.Params["Id"]);
            cmd.ExecuteNonQuery();

            cmd = new SqlCommand("UPDATE Orders SET status = 'paid', isPaid = 1, PaidAt = @Now WHERE Id IN (SELECT OrderId FROM OrderPayments WHERE PaymentId = @Id)", conn);
            cmd.Parameters.AddWithValue("@Now", DateTime.Now);
            cmd.Parameters.AddWithValue("@Id", Request.Params["Id"]);
            cmd.ExecuteNonQuery();

            cmd = new SqlCommand("SELECT OrderId FROM OrderPayments WHERE PaymentId = @Id", conn);
            cmd.Parameters.AddWithValue("@Id", Request.Params["Id"]);
            SqlDataReader reader = cmd.ExecuteReader();
            string Ids = string.Empty;
            string lastId = string.Empty;
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    lastId = reader["OrderId"].ToString();
                    Ids += "#"+ reader["OrderId"]+", ";
                }
                Ids = Ids.Substring(0, Ids.Length - 2);
            }

            reader.Close();
            conn.Close();
            string url = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/Customer/Orders/List.aspx";
            Mail.sendPaymentSuccessEmail(Request.Params["Id"], Ids, url, Request.Params["email"], Server.MapPath("~/Email/Payment.html"));
        }
    }
}