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
            DBConnect.Open();
            SqlCommand cmd = new SqlCommand("SELECT O.Id , O.AmountToPay*100 AS Amount FROM Orders O WHERE O.isPaid = 0 AND O.CustomerId = @CustomerId", DBConnect.conn);
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
            cmd = new SqlCommand("INSERT INTO Payments (Status, Amount, CreatedAt, UpdatedAt) OUTPUT INSERTED.ID VALUES ('pending', @Amount, @cNow, @uNow)", DBConnect.conn);
            cmd.Parameters.AddWithValue("@Amount", Convert.ToDouble(total / 100));
            cmd.Parameters.AddWithValue("@cNow", DateTime.Now);
            cmd.Parameters.AddWithValue("@uNow", DateTime.Now);
            
            int paymentId = 0;
            try
            {
                paymentId = (int)cmd.ExecuteScalar();
            }
            catch
            {
                Response.StatusCode = 500;
                Server.Transfer("/Error/500.aspx");
                return;
            }

            cmd = new SqlCommand("INSERT INTO OrderPayments (PaymentId, OrderId) (SELECT @PaymentId, Id FROM Orders WHERE isPaid = 0 AND CustomerId = @CustomerId);", DBConnect.conn);
            cmd.Parameters.AddWithValue("@PaymentId", paymentId);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            cmd.ExecuteNonQuery();
            DBConnect.conn.Close();

            StripeConfiguration.ApiKey = ConfigurationManager.AppSettings["StripeApiKey"].ToString();

            var options = new SessionCreateOptions
            {
                SuccessUrl = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/Customer/Payments/PaymentSuccess.aspx?Id="+paymentId + "&email=" + Membership.GetUser().Email,
                CancelUrl = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/Customer/Payments/Cancel.aspx?Id=" + paymentId + "&email=" + Membership.GetUser().Email,
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