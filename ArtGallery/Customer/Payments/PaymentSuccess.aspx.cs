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
            conn.Close();
        }
    }
}