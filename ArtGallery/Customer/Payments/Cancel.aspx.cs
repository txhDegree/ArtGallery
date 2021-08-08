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
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("UPDATE Payments SET status = 'cancelled', UpdatedAt = @Now WHERE Id = @Id", conn);
            cmd.Parameters.AddWithValue("@Now", DateTime.Now);
            cmd.Parameters.AddWithValue("@Id", Request.Params["Id"]);
            cmd.ExecuteNonQuery();
            conn.Close();
        }
    }
}