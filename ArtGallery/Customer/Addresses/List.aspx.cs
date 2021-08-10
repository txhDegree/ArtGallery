using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using System.Data.SqlClient;

namespace ArtGallery.Customer.Addresses
{
    public partial class List : System.Web.UI.Page
    {

        protected Boolean isDeleted = false;
        protected void Page_Init(object sender, EventArgs e)
        {
            ArtworkSource.SelectParameters["CustomerId"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd;
            switch (e.CommandName) {
                case "RemoveAddress":
                    cmd = new SqlCommand("DELETE FROM Addresses WHERE CustomerId = @CustomerId AND Id = @AddressId", conn);
                    cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd.Parameters.AddWithValue("@AddressId", e.CommandArgument);
                    isDeleted = cmd.ExecuteNonQuery() > 0;
                    break;
            }
            conn.Close();
            Repeater1.DataBind();
        }

        protected void Repeater1_PreRender(object sender, EventArgs e)
        {
            if (Repeater1.Items.Count < 1) {
                NoRecords.Visible = true;
                Repeater1.Visible = false;
            }
        }
    }
}