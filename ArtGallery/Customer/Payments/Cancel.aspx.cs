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
    public partial class Cancel : System.Web.UI.Page
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
            SqlCommand cmd = new SqlCommand("UPDATE Payments SET status = 'cancelled', UpdatedAt = @Now WHERE Id = @Id", DBConnect.conn);
            cmd.Parameters.AddWithValue("@Now", DateTime.Now);
            cmd.Parameters.AddWithValue("@Id", id);
            try
            {
                cmd.ExecuteNonQuery();
            } catch
            {
                Response.StatusCode = 500;
                Server.Transfer("/Error/500.aspx");
                return;
            }
            DBConnect.conn.Close();
        }
    }
}