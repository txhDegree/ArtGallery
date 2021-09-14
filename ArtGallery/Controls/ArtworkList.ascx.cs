﻿using System;
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
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd;
            SqlDataReader reader;
            switch (e.CommandName)
            {
                case "RemoveFromWishlist":
                    cmd = new SqlCommand("SELECT * FROM Wishlists WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", conn);
                    cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
                    cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                    reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Close();
                        cmd = new SqlCommand("DELETE FROM Wishlists WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", conn);
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
                    cmd = new SqlCommand("SELECT * FROM Wishlists WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", conn);
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
                        cmd = new SqlCommand("INSERT INTO Wishlists (CustomerId, ArtworkId, AddedAt) VALUES (@CustomerId, @ArtworkId, @AddedAt)", conn);
                        cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
                        cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                        cmd.Parameters.AddWithValue("@AddedAt", DateTime.Now);
                        isAddedToWishlist = cmd.ExecuteNonQuery() > 0;
                    }
                    break;
                case "AddToCart":
                    cmd = new SqlCommand("SELECT * FROM Carts WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", conn);
                    cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
                    cmd.Parameters.AddWithValue("@ArtworkId", e.CommandArgument);
                    reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Close();
                        cmd = new SqlCommand("UPDATE Carts SET Quantity = Quantity + @Qty, AddedAt = @AddedAt WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", conn);
                    }
                    else
                    {
                        reader.Close();
                        cmd = new SqlCommand("INSERT INTO Carts (CustomerId, ArtworkId, Quantity, AddedAt) VALUES (@CustomerId, @ArtworkId, @Qty, @AddedAt)", conn);
                    }
                    cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
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
                Pagination.Visible = false;
            }
        }
    }
}