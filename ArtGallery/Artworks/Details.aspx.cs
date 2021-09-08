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
        protected void Page_Load(object sender, EventArgs e)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd;
            SqlDataReader reader;
            cmd = new SqlCommand("SELECT * FROM Artworks A LEFT JOIN aspnet_Users U ON A.ArtistId = U.Userid  WHERE A.Id = @ArtworkId", conn);
            cmd.Parameters.AddWithValue("@ArtworkId", Request.Params["Id"]);
            reader = cmd.ExecuteReader();
            if (reader.HasRows) {
                reader.Read();
                
                lblTitle.InnerText = reader["Title"].ToString();
                lblDesc.InnerText = reader["Description"].ToString();
                lblPrice.InnerText = "RM " + ((Decimal)reader["Price"]).ToString("F");
                lblStockQty.InnerText = reader["StockQuantity"].ToString();
                lblArtistName.Text = reader["UserName"].ToString();
                lblYear.Text = Convert.ToDateTime(reader["Year"].ToString()).Year.ToString();

                txtQty.Attributes.Add("max", reader["StockQuantity"].ToString());
                rangeValidator.MaximumValue = reader["StockQuantity"].ToString();
                rangeValidator.Text = "The quantity must be from 1 to " + reader["StockQuantity"].ToString();

                image.Src = Convert.IsDBNull(reader["Image"]) ? "/public/img/image.svg" : "/Storage/Artworks/" + reader["Image"].ToString();

            }
            reader.Close();
            conn.Close();
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
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
            cmd = new SqlCommand("SELECT * FROM Carts WHERE CustomerId = @CustomerId AND ArtworkId = @ArtworkId", conn);
            cmd.Parameters.AddWithValue("@CustomerId", user.ProviderUserKey);
            cmd.Parameters.AddWithValue("@ArtworkId", Request.Params["Id"]);
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
            cmd.Parameters.AddWithValue("@ArtworkId", Request.Params["Id"]);
            cmd.Parameters.AddWithValue("@Qty", int.Parse(txtQty.Text));
            cmd.Parameters.AddWithValue("@AddedAt", DateTime.Now);

            isAddedToCart = cmd.ExecuteNonQuery() > 0;
            conn.Close();
        }
    }
}