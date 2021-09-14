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
            PagingSource.SelectParameters["CustomerId"].DefaultValue = ArtworkSource.SelectParameters["CustomerId"].DefaultValue;
            Pagination.initialize(ArtworkSource, PagingSource, 12);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            DBConnect.Open();
            SqlCommand cmd = new SqlCommand("SELECT COUNT(isPaid) FROM Orders WHERE isPaid = 0 AND CustomerId = @CustomerId", DBConnect.conn);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            try
            {
                var result = cmd.ExecuteScalar();
                paymentRequired = Convert.IsDBNull(result) ? false : (int)result > 0;
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