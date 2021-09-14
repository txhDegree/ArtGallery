using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArtGallery.Customer.Orders
{
    public partial class Details : System.Web.UI.Page
    {
        protected string status = "";
        protected Boolean isUpdated = false;
        protected void Page_Init(object sender, EventArgs e)
        {
            string id = Request.QueryString["Id"];
            if (string.IsNullOrEmpty(id))
            {
                Response.StatusCode = 404;
                Server.Transfer("/Error/404.aspx");
                return;
            }
            OrderDetailsSource.SelectParameters["OrderId"].DefaultValue = id;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (!(isUpdated || !IsPostBack))
                return;
            string id = Request.QueryString["Id"];
            if (string.IsNullOrEmpty(id))
            {
                Response.StatusCode = 404;
                Server.Transfer("/Error/404.aspx");
                return;
            }
            if (!DBConnect.Open())
            {
                Response.StatusCode = 503;
                Server.Transfer("/Error/503.aspx");
                return;
            }
            SqlCommand cmd = new SqlCommand("SELECT U.UserName, O.*, S.ReceiverName, S.ReceiverContact, S.TrackingNo, S.Address, S.PostalCode, C.CityName, S2.StateName FROM Orders O LEFT JOIN Shipments S ON O.ShipmentId = S.Id LEFT JOIN Cities C ON S.City = C.CityId LEFT JOIN States S2 ON S.State = S2.StateId , aspnet_Users U WHERE O.Id = @OrderId AND O.ArtistId = U.UserId AND O.CustomerId = @CustomerId", DBConnect.conn);
            cmd.Parameters.AddWithValue("@OrderId", id);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                try
                {
                    lblOrderId.InnerText = "#" + Convert.ToInt32(reader["Id"]).ToString("00000.##");
                    lblOrderAt.InnerText = smallOrderAt.InnerText = Convert.ToDateTime(reader["Date"]).ToString("dd/MM/yyyy hh:mm tt");
                }
                catch
                {
                    Response.StatusCode = 500;
                    Server.Transfer("/Error/500.aspx");
                    return;
                }

                if (Convert.IsDBNull(reader["CompleteAt"]))
                {
                    progressCompleteAt.Visible = false;
                }
                else
                {
                    progressCompleteAt.Visible = true;
                    lblCompleteAt.InnerText = smallCompleteAt.InnerText = Convert.ToDateTime(reader["CompleteAt"]).ToString("dd/MM/yyyy hh:mm tt");
                }

                if (Convert.IsDBNull(reader["ShippingAt"]))
                {
                    progressShippingAt.Visible = false;
                }
                else
                {
                    progressShippingAt.Visible = true;
                    lblShippingAt.InnerText = smallShippingAt.InnerText = Convert.ToDateTime(reader["ShippingAt"]).ToString("dd/MM/yyyy hh:mm tt");
                }

                if (Convert.IsDBNull(reader["PreparingAt"]))
                {
                    progressPreparingAt.Visible = false;
                }
                else
                {
                    progressPreparingAt.Visible = true;
                    lblPreparingAt.InnerText = smallPreparingAt.InnerText = Convert.ToDateTime(reader["PreparingAt"]).ToString("dd/MM/yyyy hh:mm tt");
                }

                if (Convert.IsDBNull(reader["PaidAt"]))
                {
                    progressPaidAt.Visible = false;
                }
                else
                {
                    progressPaidAt.Visible = true;
                    lblPaidAt.InnerText = smallPaidAt.InnerText = Convert.ToDateTime(reader["PaidAt"]).ToString("dd/MM/yyyy hh:mm tt");
                }
                lblTrackingNo.InnerText = Convert.IsDBNull(reader["TrackingNo"]) ? "-" : reader["TrackingNo"].ToString();
                lblArtistName.InnerText = reader["UserName"].ToString();
                try
                {
                    lblAmountToPay.InnerText = "RM " + Convert.ToDecimal(reader["AmountToPay"]).ToString("F");
                }
                catch
                {
                    Response.StatusCode = 500;
                    Server.Transfer("/Error/500.aspx");
                    return;
                }
                lblReceiverName.InnerText = reader["ReceiverName"].ToString();
                lblReceiverContact.InnerText = "+60" + reader["ReceiverContact"].ToString();
                lblShippingAddress.InnerText = reader["Address"].ToString() + ", " + reader["PostalCode"].ToString() + ", " + reader["CityName"].ToString() + ", " + reader["StateName"].ToString();

                status = reader["Status"].ToString().Trim();
            }
            DBConnect.conn.Close();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.PreRender += Page_PreRender;
        }

        protected void btnComplete_Click(object sender, EventArgs e)
        {
            DBConnect.Open();
            SqlCommand cmd = new SqlCommand("UPDATE Orders SET CompleteAt = @Now, Status = 'complete' WHERE Id = @Id AND CustomerId = @CustomerId", DBConnect.conn);
            cmd.Parameters.AddWithValue("@Now", DateTime.Now);
            cmd.Parameters.AddWithValue("@Id", Request.Params["Id"]);
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);
            try
            {
                isUpdated = cmd.ExecuteNonQuery() > 0;
            }
            catch
            {
                Response.StatusCode = 500;
                Server.Transfer("/Error/500.aspx");
                return;
            }
            DBConnect.conn.Close();
        }
    }
}