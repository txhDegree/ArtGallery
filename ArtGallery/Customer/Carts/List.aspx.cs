using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using Stripe;
using Stripe.Checkout;

namespace ArtGallery.Customer.Carts
{
    public partial class List : System.Web.UI.Page
    {
        protected Boolean checkoutAvailable = true;
        protected Boolean isDeleted = false;
        protected void Page_Init(object sender, EventArgs e)
        {
            ArtworkSource.SelectParameters["CustomerId"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
            AddressSource.SelectParameters["CustomerId"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (!(isDeleted || !IsPostBack))
                return;
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT SUM([C].[Quantity]) AS TotalCount, SUM([A].[Price] * [C].[Quantity]) AS TotalAmount FROM[Artworks] A RIGHT JOIN[Carts] C ON[A].[Id] = [C].[ArtworkId], [aspnet_Users] U WHERE([A].[isVisible] = 1) AND CustomerId = @CustomerId AND[A].[ArtistId] = [U].[UserId]", conn); ;
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            SqlDataReader reader;
            reader = cmd.ExecuteReader();
            
            if (reader.HasRows)
            {
                reader.Read();
                checkoutAvailable = !Convert.IsDBNull(reader["TotalCount"]);
                if (!Convert.IsDBNull(reader["TotalCount"])) {
                    lblTotalCount.InnerText = reader["TotalCount"].ToString();
                    lblTotalAmount.InnerText = "RM " + ((Decimal)reader["TotalAmount"]).ToString("F");
                }

            }
            reader.Close();
            conn.Close();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.PreRender += Page_PreRender;
        }

        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("DELETE FROM Carts WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", conn); ;
            cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            isDeleted = cmd.ExecuteNonQuery() > 0;
            conn.Close();
            Repeater1.DataBind();
        }

        protected void Repeater1_PreRender(object sender, EventArgs e)
        {
            if (Repeater1.Items.Count < 1)
            {
                NoRecords.Visible = true;
                Repeater1.Visible = false;
            }
        }
    }
}