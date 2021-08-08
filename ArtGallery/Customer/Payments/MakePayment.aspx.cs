using Stripe;
using Stripe.Checkout;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArtGallery.Customer.Payments
{
    public partial class MakePayment : System.Web.UI.Page
    {
        protected string sessionId = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT O.Id , O.AmountToPay*100 AS Amount FROM Orders O WHERE O.isPaid = 0 AND O.CustomerId = @CustomerId", conn); ;
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            SqlDataReader reader = cmd.ExecuteReader();
            List<SessionLineItemOptions> items = new List<SessionLineItemOptions>();
            int total = 0;
            if (reader.HasRows)
            {
                while (reader.Read()) {
                    items.Add(new SessionLineItemOptions
                    {
                        Name = "Order #" + Convert.ToInt32(reader["Id"]).ToString("00000.##"),
                        Amount = Convert.ToInt64(reader["Amount"]),
                        Currency = "myr",
                        Quantity = 1
                    });
                    total += Convert.ToInt32(reader["Amount"]);
                }
            }
            reader.Close();

            // create new payment record in db
            cmd = new SqlCommand("INSERT INTO Payments (Status, Amount, CreatedAt, UpdatedAt) OUTPUT INSERTED.ID VALUES ('pending', @Amount, @cNow, @uNow)", conn);
            cmd.Parameters.AddWithValue("@Amount", (double)total / 100);
            cmd.Parameters.AddWithValue("@cNow", DateTime.Now);
            cmd.Parameters.AddWithValue("@uNow", DateTime.Now);
            int paymentId = (int)cmd.ExecuteScalar();

            cmd = new SqlCommand("INSERT INTO OrderPayments (PaymentId, OrderId) (SELECT @PaymentId, Id FROM Orders WHERE isPaid = 0 AND CustomerId = @CustomerId);", conn);
            cmd.Parameters.AddWithValue("@PaymentId", paymentId);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            cmd.ExecuteNonQuery();
            conn.Close();

            StripeConfiguration.ApiKey = "sk_test_51JM6faCafuyPLxsgbrqltPfR5Qs0i6kRkROjFs7SbI8OmokeCG5ewUePPuQlcW8DUqtoRWVtZFV5No6cqsfqGzDH00A1Rwpr2n";

            var options = new SessionCreateOptions
            {
                SuccessUrl = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/Customer/Payments/PaymentSuccess.aspx?Id="+paymentId,
                CancelUrl = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/Customer/Payments/Cancel.aspx?Id=" + paymentId,
                PaymentMethodTypes = new List<string> { "card" },
                LineItems = items,
                Mode = "payment",
            };
            var service = new SessionService();
            Session session = service.Create(options);
            sessionId = session.Id;
        }
    }
}