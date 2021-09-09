using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;

namespace ArtGallery.Customer.Wishlists
{
    public partial class List : System.Web.UI.Page
    {

        protected Boolean isAddedToCart = false;
        protected Boolean isRemovedFromWishlist = false;
        protected Boolean unableToRemovedFromWishlist = false;
        protected void Page_Init(object sender, EventArgs e)
        {
            ArtworkSource.SelectParameters["CustomerId"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
            PagingSource.SelectParameters["CustomerId"].DefaultValue = ArtworkSource.SelectParameters["CustomerId"].DefaultValue;
            Pagination.initialize(ArtworkSource, PagingSource, 12);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd;
            SqlDataReader reader;
            switch (e.CommandName) {
                case "RemoveFromWishlist":
                    cmd = new SqlCommand("SELECT * FROM Wishlists WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", conn);
                    cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                    reader = cmd.ExecuteReader();
                    if (reader.HasRows) {
                        reader.Close();
                        cmd = new SqlCommand("DELETE FROM Wishlists WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", conn);
                        cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                        cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                        isRemovedFromWishlist = cmd.ExecuteNonQuery() > 0;
                    } else {
                        reader.Close();
                        unableToRemovedFromWishlist = true;
                    }
                    break;
                case "AddToCart":
                    cmd = new SqlCommand("SELECT * FROM Carts WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", conn);
                    cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                    reader = cmd.ExecuteReader();
                    if (reader.HasRows) {
                        reader.Close();
                        cmd = new SqlCommand("UPDATE Carts SET Quantity = Quantity + @Qty, AddedAt = @AddedAt WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", conn);
                    } else {
                        reader.Close();
                        cmd = new SqlCommand("INSERT INTO Carts (CustomerId, ArtworkId, Quantity, AddedAt) VALUES (@CustomerId, @ArtworkId, @Qty, @AddedAt)", conn);
                    }
                    cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                    cmd.Parameters.AddWithValue("@Qty", 1);
                    cmd.Parameters.AddWithValue("@AddedAt", DateTime.Now);

                    isAddedToCart = cmd.ExecuteNonQuery() > 0;
                    break;
            }
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