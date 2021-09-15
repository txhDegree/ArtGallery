using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArtGallery.Controls
{
    public partial class ArtworkList : System.Web.UI.UserControl
    {
        public SqlDataSource AllSource { get; set; }
        public SqlDataSource PagingSource { get; set; }

        protected Boolean isAddedToCart = false;
        protected Boolean isRemovedFromWishlist = false;
        protected Boolean unableToRemovedFromWishlist = false;
        protected Boolean isAddedToWishlist = false;
        protected Boolean isInWishlist = false;
        protected Boolean maxOfCart = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            Pagination.initialize(AllSource, PagingSource, 12);
        }

        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            MembershipUser user = Membership.GetUser();
            if (user == null)
            {
                FormsAuthentication.RedirectToLoginPage();
                return;
            }
            if (Roles.GetRolesForUser(user.UserName)[0] != "Customer")
            {
                FormsAuthentication.RedirectToLoginPage();
                return;
            }
            DBConnect.Open();
            SqlCommand cmd;
            SqlDataReader reader;
            switch (e.CommandName)
            {
                case "RemoveFromWishlist":
                    cmd = new SqlCommand("SELECT * FROM Wishlists WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", DBConnect.conn);
                    cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
                    cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                    reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Close();
                        cmd = new SqlCommand("DELETE FROM Wishlists WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", DBConnect.conn);
                        cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
                        cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                        isRemovedFromWishlist = cmd.ExecuteNonQuery() > 0;
                    }
                    else
                    {
                        reader.Close();
                        unableToRemovedFromWishlist = true;
                    }
                    break;
                case "AddToWishlist":
                    cmd = new SqlCommand("SELECT * FROM Wishlists WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", DBConnect.conn);
                    cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
                    cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                    reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Close();
                        isInWishlist = true;
                    }
                    else
                    {
                        reader.Close();
                        cmd = new SqlCommand("INSERT INTO Wishlists (CustomerId, ArtworkId, AddedAt) VALUES (@CustomerId, @ArtworkId, @AddedAt)", DBConnect.conn);
                        cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
                        cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                        cmd.Parameters.AddWithValue("@AddedAt", DateTime.Now);
                        isAddedToWishlist = cmd.ExecuteNonQuery() > 0;
                    }
                    break;
                case "AddToCart":
                    cmd = new SqlCommand("SELECT * FROM Carts WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", DBConnect.conn);
                    cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
                    cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                    reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        int total = Convert.ToInt32(reader["Quantity"]) + 1;
                        reader.Close();
                        cmd = new SqlCommand("SELECT StockQuantity FROM Artworks WHERE Id = @ArtworkId", DBConnect.conn);
                        cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                        int stockQty = Convert.ToInt32(cmd.ExecuteScalar());

                        if (stockQty < total)
                        {
                            maxOfCart = true;
                            DBConnect.conn.Close();
                            return;
                        }

                        cmd = new SqlCommand("UPDATE Carts SET Quantity = Quantity + @Qty, AddedAt = @AddedAt WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", DBConnect.conn);
                    }
                    else
                    {
                        reader.Close();
                        cmd = new SqlCommand("INSERT INTO Carts (CustomerId, ArtworkId, Quantity, AddedAt) VALUES (@CustomerId, @ArtworkId, @Qty, @AddedAt)", DBConnect.conn);
                    }
                    cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
                    cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                    cmd.Parameters.AddWithValue("@Qty", 1);
                    cmd.Parameters.AddWithValue("@AddedAt", DateTime.Now);

                    isAddedToCart = cmd.ExecuteNonQuery() > 0;
                    break;
            }
            DBConnect.conn.Close();
            Repeater1.DataBind();
        }

        protected void Repeater1_PreRender(object sender, EventArgs e)
        {
            System.Data.DataView dataView = (System.Data.DataView)PagingSource.Select(DataSourceSelectArguments.Empty);
            if ((dataView == null ? 0 : dataView.Count) < 1)
            {
                NoRecords.Visible = true;
                Repeater1.Visible = false;
            } else
            {
                NoRecords.Visible = false;
                Repeater1.Visible = true;
            }
        }

        public void Reload() {
            Repeater1.DataBind();
            System.Data.DataView dataView = (System.Data.DataView)PagingSource.Select(DataSourceSelectArguments.Empty);
            if ((dataView == null ? 0 : dataView.Count) < 1)
            {
                NoRecords.Visible = true;
                Repeater1.Visible = false;
            } else
            {
                NoRecords.Visible = false;
                Repeater1.Visible = true;
            }
            Pagination.initialize(AllSource, PagingSource, 12);

        }
    }
}