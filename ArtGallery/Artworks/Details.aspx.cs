using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using System.Data.SqlClient;

namespace ArtGallery.Customer.Artworks
{
    public partial class Details : System.Web.UI.Page
    {
        protected Boolean isAddedToCart = false;
        protected Boolean isOutOfStock = false;
        protected Boolean maxOfCart = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["Id"];
            if (string.IsNullOrEmpty(id))
            {
                Response.StatusCode = 404;
                Server.Transfer("/Error/404.aspx");
                return;
            }
            DBConnect.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Artworks A LEFT JOIN aspnet_Users U ON A.ArtistId = U.Userid  WHERE A.Id = @ArtworkId", DBConnect.conn);
            cmd.Parameters.AddWithValue("@ArtworkId", id);
            SqlDataReader reader;
            try
            {
                reader = cmd.ExecuteReader();
            }
            catch
            {
                Response.StatusCode = 500;
                Server.Transfer("/Error/500.aspx");
                return;
            }
            if (reader.Read()) {
                try
                {
                    lblPrice.InnerText = "RM " + Convert.ToDecimal(reader["Price"]).ToString("F");
                }
                catch
                {
                    Response.StatusCode = 500;
                    Server.Transfer("/Error/500.aspx");
                    return;
                }
                lblTitle.InnerText = reader["Title"].ToString();
                lblDesc.InnerText = reader["Description"].ToString();
                lblStockQty.InnerText = reader["StockQuantity"].ToString();
                lblArtistName.Text = reader["UserName"].ToString();
                lblYear.Text = Convert.ToDateTime(reader["Year"].ToString()).Year.ToString();

                if(Convert.ToInt32(reader["StockQuantity"].ToString()) <= 0)
                {
                    isOutOfStock = true;
                } else
                {
                    txtQty.Attributes.Add("max", reader["StockQuantity"].ToString());
                    rangeValidator.MaximumValue = reader["StockQuantity"].ToString();
                    rangeValidator.Text = "The quantity must be from 1 to " + reader["StockQuantity"].ToString();
                }

                ArtistUrl.HRef = "/Artworks/Artist.aspx?Artist=" + reader["UserName"].ToString();

                image.Src = Convert.IsDBNull(reader["Image"]) ? "/public/img/image.svg" : "/Storage/Artworks/" + reader["Image"].ToString();

            }
            reader.Close();
            DBConnect.conn.Close();
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            string id = Request.QueryString["Id"];
            if (string.IsNullOrEmpty(id))
            {
                Response.StatusCode = 404;
                Server.Transfer("/Error/404.aspx");
                return;
            }
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

            int qty = 0;
            try
            {
                qty = Convert.ToInt32(txtQty.Text);
            }
            catch
            {
                Response.StatusCode = 500;
                Server.Transfer("/Error/500.aspx");
                return;
            }

            DBConnect.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Carts WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", DBConnect.conn);
            cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
            cmd.Parameters.AddWithValue("@ArtworkId", Request.Params["Id"]);
            SqlDataReader reader;
            try
            {
                reader = cmd.ExecuteReader();
            }
            catch
            {
                Response.StatusCode = 500;
                Server.Transfer("/Error/500.aspx");
                return;
            }

            if (reader.Read())
            {
                int total = 0;
                try
                {
                     total = Convert.ToInt32(reader["Quantity"]) + qty;
                }
                catch
                {
                    Response.StatusCode = 500;
                    Server.Transfer("/Error/500.aspx");
                    return;
                }
                reader.Close();
                cmd = new SqlCommand("SELECT StockQuantity FROM Artworks WHERE Id = @ArtworkId", DBConnect.conn);
                cmd.Parameters.AddWithValue("@ArtworkId", Request.Params["Id"]);

                int stockQty = Convert.ToInt32(cmd.ExecuteScalar());
                try
                {
                    stockQty = Convert.ToInt32(cmd.ExecuteScalar());
                }
                catch
                {
                    Response.StatusCode = 500;
                    Server.Transfer("/Error/500.aspx");
                    return;
                }

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
            cmd.Parameters.AddWithValue("@ArtworkId", id);
            cmd.Parameters.AddWithValue("@Qty", qty);
            cmd.Parameters.AddWithValue("@AddedAt", DateTime.Now);
            try
            {
                isAddedToCart = cmd.ExecuteNonQuery() > 0;
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