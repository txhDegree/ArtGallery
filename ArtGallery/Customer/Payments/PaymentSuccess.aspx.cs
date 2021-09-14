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
            string id = Request.QueryString["Id"];
            if (string.IsNullOrEmpty(id))
            {
                Response.StatusCode = 404;
                Server.Transfer("/Error/404.aspx");
                return;
            }
            DBConnect.Open();
            SqlDataReader reader;
            try
            {
                SqlCommand cmd = new SqlCommand("UPDATE Payments SET status = 'paid', UpdatedAt = @Now WHERE Id = @Id", DBConnect.conn);
                cmd.Parameters.AddWithValue("@Now", DateTime.Now);
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.ExecuteNonQuery();

                cmd = new SqlCommand("UPDATE Orders SET status = 'paid', isPaid = 1, PaidAt = @Now WHERE Id IN (SELECT OrderId FROM OrderPayments WHERE PaymentId = @Id)", DBConnect.conn);
                cmd.Parameters.AddWithValue("@Now", DateTime.Now);
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.ExecuteNonQuery();

                cmd = new SqlCommand("SELECT OrderId FROM OrderPayments WHERE PaymentId = @Id", DBConnect.conn);
                cmd.Parameters.AddWithValue("@Id", id);
                reader = cmd.ExecuteReader();
            } catch
            {
                Response.StatusCode = 500;
                Server.Transfer("/Error/500.aspx");
                return;
            }
            string Ids = string.Empty;
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    Ids += "#"+ reader["OrderId"]+", ";
                }
                Ids = Ids.Substring(0, Ids.Length - 2);
            }

            reader.Close();
            DBConnect.conn.Close();
            string url = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/Customer/Orders/List.aspx";
            Mail.sendPaymentSuccessEmail(id, Ids, url, Request.Params["email"], Server.MapPath("~/Email/Payment.html"));
        }
    }
}