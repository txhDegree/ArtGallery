using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;

namespace ArtGallery.Customer.Orders
{
    public partial class NewOrder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT DISTINCT([U].[UserId]) AS ArtistId FROM Carts [C] LEFT JOIN Artworks [A] LEFT JOIN aspnet_Users [U] ON [A].[ArtistId] = U.[UserId] ON [C].[ArtworkId] = [A].[Id] WHERE [C].[CustomerId] = @CustomerId", conn);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            SqlDataReader reader = cmd.ExecuteReader();
            
            if (reader.HasRows)
            {
                while (reader.Read()) {
                    string artistId = reader["ArtistId"].ToString();
                    // Get total amount to pay for artist artwork
                    SqlCommand cmd2 = new SqlCommand("SELECT SUM(C.Quantity * A.Price) as TotalAmount FROM Carts C LEFT JOIN Artworks A ON C.ArtworkId = A.Id WHERE C.CustomerId = @CustomerId AND A.ArtistId = @ArtistId", conn);
                    cmd2.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd2.Parameters.AddWithValue("@ArtistId", artistId);
                    double totalAmount = Convert.ToDouble(cmd2.ExecuteScalar().ToString());

                    // create new order
                    cmd2 = new SqlCommand("INSERT INTO Orders (Date, Status, TotalAmount, ShippingFee, AmountToPay, isPaid, CustomerId) OUTPUT INSERTED.Id VALUES (@Date, 'pending', @TotalAmount, 5.00, @AmountToPay, 0, @CustomerId)", conn);
                    cmd2.Parameters.AddWithValue("@Date", DateTime.Now);
                    cmd2.Parameters.AddWithValue("@TotalAmount", totalAmount);
                    cmd2.Parameters.AddWithValue("@AmountToPay", totalAmount + 5);
                    cmd2.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    int orderId = (int)cmd2.ExecuteScalar();

                    // create order details
                    cmd2 = new SqlCommand("INSERT INTO OrderDetail(OrderId, ArtworkId, ArtworkTitle, UnitPrice, Quantity) (SELECT @OrderId, C.ArtworkId, A.Title, A.Price, C.Quantity FROM Carts C LEFT JOIN Artworks A ON C.ArtworkId = A.Id WHERE C.CustomerId = @CustomerId AND A.ArtistId = @ArtistId)", conn);
                    cmd2.Parameters.AddWithValue("@OrderId", orderId);
                    cmd2.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd2.Parameters.AddWithValue("@ArtistId", artistId);
                    cmd2.ExecuteNonQuery();
                }

                SqlCommand cmd3 = new SqlCommand("DELETE FROM Carts WHERE CustomerId = @CustomerId", conn);
                cmd3.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                cmd3.ExecuteNonQuery();
            }
            reader.Close();
            conn.Close();

        }
    }
}