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
            int addressId = Convert.ToInt32(Request.Params["Id"]);
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd;
            // Validate whether purchased amount is in range of stock amount
            cmd = new SqlCommand("SELECT SUM(CASE WHEN TAP > StockQuantity THEN 1 ELSE 0 END) AS GreaterThan FROM (SELECT ArtworkId, SUM(Quantity) AS TAP FROM Carts WHERE CustomerId = @CustomerId GROUP BY ArtworkId) C, Artworks A WHERE C.ArtworkId = A.Id", conn);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            int result = (int)cmd.ExecuteScalar();
            if(result > 0)
            {
                // invalid
                conn.Close();
                Response.Redirect("/Customer/Orders/OutOfStock.aspx");
            }
            cmd = new SqlCommand("SELECT DISTINCT([U].[UserId]) AS ArtistId FROM Carts [C] LEFT JOIN Artworks [A] LEFT JOIN aspnet_Users [U] ON [A].[ArtistId] = U.[UserId] ON [C].[ArtworkId] = [A].[Id] WHERE [C].[CustomerId] = @CustomerId", conn);
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
                    
                    // create order shipment
                    cmd2 = new SqlCommand("INSERT INTO Shipments(ReceiverName, ReceiverContact, Address, City, PostalCode, State) OUTPUT INSERTED.Id SELECT ReceiverName, ReceiverContact, Address, City, PostalCode, State FROM Addresses WHERE Id = @Id", conn);
                    cmd2.Parameters.AddWithValue("@Id", addressId);
                    int shippingId = (int)cmd2.ExecuteScalar();

                    // create new order
                    cmd2 = new SqlCommand("INSERT INTO Orders (Date, Status, TotalAmount, ShippingFee, AmountToPay, isPaid, CustomerId, ArtistId, ShipmentId) OUTPUT INSERTED.Id VALUES (@Date, 'pending', @TotalAmount, 5.00, @AmountToPay, 0, @CustomerId, @ArtistId, @ShipmentId)", conn);
                    cmd2.Parameters.AddWithValue("@Date", DateTime.Now);
                    cmd2.Parameters.AddWithValue("@TotalAmount", totalAmount);
                    cmd2.Parameters.AddWithValue("@AmountToPay", totalAmount + 5);
                    cmd2.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd2.Parameters.AddWithValue("@ArtistId", artistId);
                    cmd2.Parameters.AddWithValue("@ShipmentId", shippingId);
                    int orderId = (int)cmd2.ExecuteScalar();

                    // create order details
                    cmd2 = new SqlCommand("INSERT INTO OrderDetail(OrderId, ArtworkId, ArtworkTitle, UnitPrice, Quantity) (SELECT @OrderId, C.ArtworkId, A.Title, A.Price, C.Quantity FROM Carts C LEFT JOIN Artworks A ON C.ArtworkId = A.Id WHERE C.CustomerId = @CustomerId AND A.ArtistId = @ArtistId)", conn);
                    cmd2.Parameters.AddWithValue("@OrderId", orderId);
                    cmd2.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd2.Parameters.AddWithValue("@ArtistId", artistId);
                    cmd2.ExecuteNonQuery();
                }
                SqlCommand cmd3 = new SqlCommand("SELECT * FROM Carts WHERE CustomerId = @CustomerId", conn);
                cmd3.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                SqlDataReader reader3 = cmd3.ExecuteReader();
                SqlCommand cmd4;
                if(reader3.HasRows)
                while (reader3.Read()) {
                    cmd4 = new SqlCommand("UPDATE Artworks SET StockQuantity = StockQuantity-@Quantity WHERE Id = @Id", conn);
                    cmd4.Parameters.AddWithValue("@Quantity", Convert.ToInt32(reader3["Quantity"]));
                    cmd4.Parameters.AddWithValue("@Id", Convert.ToInt32(reader3["ArtworkId"]));
                    Console.WriteLine(cmd4.ExecuteNonQuery());
                }
                reader3.Close();

                cmd3 = new SqlCommand("DELETE FROM Carts WHERE CustomerId = @CustomerId", conn);
                cmd3.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                cmd3.ExecuteNonQuery();
            }
            reader.Close();
            conn.Close();

        }
    }
}