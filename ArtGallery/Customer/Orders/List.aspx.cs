using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArtGallery.Customer.Orders
{
    public partial class List : System.Web.UI.Page
    {
        protected Boolean paymentRequired = true;
        protected void Page_Init(object sender, EventArgs e)
        {
            ArtworkSource.SelectParameters["CustomerId"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT COUNT(isPaid) FROM Orders WHERE isPaid = 0 AND CustomerId = @CustomerId", conn);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            var result = cmd.ExecuteScalar();
            paymentRequired = Convert.IsDBNull(result) ? false : (int)result > 0;
            conn.Close();
        }
    }
}