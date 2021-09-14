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
            string id = Request.QueryString["Id"];
            if (string.IsNullOrEmpty(id))
            {
                Response.StatusCode = 404;
                Server.Transfer("/Error/404.aspx");
                return;
            }

            DBConnect.Open();
            // Validate whether purchased amount is in range of stock amount
            SqlCommand cmd = new SqlCommand("SELECT SUM(CASE WHEN TAP > StockQuantity THEN 1 ELSE 0 END) AS GreaterThan FROM (SELECT ArtworkId, SUM(Quantity) AS TAP FROM Carts WHERE CustomerId = @CustomerId GROUP BY ArtworkId) C, Artworks A WHERE C.ArtworkId = A.Id", DBConnect.conn);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            try
            {
                if(Convert.ToInt32(cmd.ExecuteScalar()) > 0)
                {
                    // invalid
                    DBConnect.conn.Close();
                    Response.Redirect("/Customer/Orders/OutOfStock.aspx");
                }
            }
            catch
            {
                Response.StatusCode = 500;
                Server.Transfer("/Error/500.aspx");
                return;
            }
            cmd = new SqlCommand("SELECT DISTINCT([U].[UserId]) AS ArtistId FROM Carts [C] LEFT JOIN Artworks [A] LEFT JOIN aspnet_Users [U] ON [A].[ArtistId] = U.[UserId] ON [C].[ArtworkId] = [A].[Id] WHERE [C].[CustomerId] = @CustomerId", DBConnect.conn);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
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
            
            if (reader.HasRows)
            {
                while (reader.Read()) {
                    string artistId = reader["ArtistId"].ToString();
                    // Get total amount to pay for artist artwork
                    SqlCommand cmd2 = new SqlCommand("SELECT SUM(C.Quantity * A.Price) as TotalAmount FROM Carts C LEFT JOIN Artworks A ON C.ArtworkId = A.Id WHERE C.CustomerId = @CustomerId AND A.ArtistId = @ArtistId", DBConnect.conn);
                    cmd2.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd2.Parameters.AddWithValue("@ArtistId", artistId);
                    double totalAmount;
                    try
                    {
                        totalAmount = Convert.ToDouble(cmd2.ExecuteScalar().ToString());
                    } catch
                    {
                        Response.StatusCode = 500;
                        Server.Transfer("/Error/500.aspx");
                        return;
                    }
                    
                    // create order shipment
                    cmd2 = new SqlCommand("INSERT INTO Shipments(ReceiverName, ReceiverContact, Address, City, PostalCode, State) OUTPUT INSERTED.Id SELECT ReceiverName, ReceiverContact, Address, City, PostalCode, State FROM Addresses WHERE Id = @Id", DBConnect.conn);
                    int shippingId = 0;
                    try
                    {
                        cmd2.Parameters.AddWithValue("@Id", Convert.ToInt32(id));
                        shippingId = Convert.ToInt32(cmd2.ExecuteScalar());
                    }
                    catch
                    {
                        Response.StatusCode = 500;
                        Server.Transfer("/Error/500.aspx");
                        return;
                    }

                    // create new order
                    cmd2 = new SqlCommand("INSERT INTO Orders (Date, Status, TotalAmount, ShippingFee, AmountToPay, isPaid, CustomerId, ArtistId, ShipmentId) OUTPUT INSERTED.Id VALUES (@Date, 'pending', @TotalAmount, 5.00, @AmountToPay, 0, @CustomerId, @ArtistId, @ShipmentId)", DBConnect.conn);
                    cmd2.Parameters.AddWithValue("@Date", DateTime.Now);
                    cmd2.Parameters.AddWithValue("@TotalAmount", totalAmount);
                    cmd2.Parameters.AddWithValue("@AmountToPay", totalAmount + 5); // Add RM 5 for shipping fee
                    cmd2.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd2.Parameters.AddWithValue("@ArtistId", artistId);
                    cmd2.Parameters.AddWithValue("@ShipmentId", shippingId);
                    int orderId;
                    try
                    {
                        orderId = Convert.ToInt32(cmd2.ExecuteScalar());
                    } catch
                    {
                        Response.StatusCode = 500;
                        Server.Transfer("/Error/500.aspx");
                        return;
                    }

                    // create order details
                    cmd2 = new SqlCommand("INSERT INTO OrderDetail(OrderId, ArtworkId, ArtworkTitle, UnitPrice, Quantity) (SELECT @OrderId, C.ArtworkId, A.Title, A.Price, C.Quantity FROM Carts C LEFT JOIN Artworks A ON C.ArtworkId = A.Id WHERE C.CustomerId = @CustomerId AND A.ArtistId = @ArtistId)", DBConnect.conn);
                    cmd2.Parameters.AddWithValue("@OrderId", orderId);
                    cmd2.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd2.Parameters.AddWithValue("@ArtistId", artistId);
                    try
                    {
                        cmd2.ExecuteNonQuery();
                    }
                    catch
                    {
                        Response.StatusCode = 500;
                        Server.Transfer("/Error/500.aspx");
                        return;
                    }
                }

                try
                {
                    SqlCommand cmd3 = new SqlCommand("UPDATE Artworks SET StockQuantity = StockQuantity - Quantity FROM Carts WHERE Id = ArtworkId AND CustomerId = @CustomerId", DBConnect.conn);
                    cmd3.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd3.ExecuteNonQuery();

                    cmd3 = new SqlCommand("DELETE FROM Carts WHERE CustomerId = @CustomerId", DBConnect.conn);
                    cmd3.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
                    cmd3.ExecuteNonQuery();
                }
                catch
                {
                    Response.StatusCode = 500;
                    Server.Transfer("/Error/500.aspx");
                    return;
                }
            }
            reader.Close();
            DBConnect.conn.Close();
        }
    }
}