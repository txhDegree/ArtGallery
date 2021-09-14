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
            PagingSource.SelectParameters["CustomerId"].DefaultValue = ArtworkSource.SelectParameters["CustomerId"].DefaultValue;

            Pagination.initialize(ArtworkSource, PagingSource, 12);
        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (!(isDeleted || !IsPostBack))
                return;
            DBConnect.Open();
            SqlCommand cmd = new SqlCommand("SELECT SUM([C].[Quantity]) AS TotalCount, SUM([A].[Price] * [C].[Quantity]) AS TotalAmount FROM[Artworks] A RIGHT JOIN[Carts] C ON[A].[Id] = [C].[ArtworkId], [aspnet_Users] U WHERE([A].[isVisible] = 1) AND CustomerId = @CustomerId AND[A].[ArtistId] = [U].[UserId]", DBConnect.conn);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            SqlDataReader reader;
            try
            {
                reader = cmd.ExecuteReader();
            } catch
            {
                Response.StatusCode = 500;
                Server.Transfer("/Error/500.aspx");
                return;
            }
            
            if (reader.Read())
            {
                checkoutAvailable = !Convert.IsDBNull(reader["TotalCount"]);
                if (checkoutAvailable) {
                    lblTotalCount.InnerText = reader["TotalCount"].ToString();
                    try
                    {
                        lblTotalAmount.InnerText = "RM " + Convert.ToDecimal(reader["TotalAmount"]).ToString("F");
                    } catch
                    {
                        Response.StatusCode = 500;
                        Server.Transfer("/Error/500.aspx");
                        return;
                    }
                }

            }
            reader.Close();
            DBConnect.conn.Close();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.PreRender += Page_PreRender;
        }

        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            DBConnect.Open();
            SqlCommand cmd = new SqlCommand("DELETE FROM Carts WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", DBConnect.conn);
            cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            try
            {
                isDeleted = cmd.ExecuteNonQuery() > 0;
            }
            catch
            {
                Response.StatusCode = 500;
                Server.Transfer("/Error/500.aspx");
                return;
            }
            DBConnect.conn.Close();
            Repeater1.DataBind();
        }

        protected void Repeater1_PreRender(object sender, EventArgs e)
        {
            if (Repeater1.Items.Count < 1)
            {
                NoRecords.Visible = true;
                Repeater1.Visible = false;
                Pagination.Visible = false;
            }
        }
    }
}