using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;

namespace ArtGallery.Customer.Addresses
{
    public partial class Edit : System.Web.UI.Page
    {
        protected Boolean isUpdated = false;
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
            DBConnect.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Addresses A LEFT JOIN Cities C ON A.City = C.CityId WHERE Id = @Id AND CustomerId = @CustomerId", DBConnect.conn);
            cmd.Parameters.AddWithValue("@Id", id);
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
            if (reader.Read())
            {
                txtTitle.Text = reader["Label"].ToString().Trim();
                txtName.Text = reader["ReceiverName"].ToString().Trim();
                txtContact.Text = reader["ReceiverContact"].ToString().Trim();
                txtAddress.Text = reader["Address"].ToString().Trim();
                ddlState.SelectedValue = reader["State"].ToString();
                SqlDataSource2.SelectParameters["StateId"].DefaultValue = reader["State"].ToString();
                hiddenCity.Value = reader["City"].ToString().Trim();
                hiddenPostCode.Value = reader["PostalCode"].ToString().Trim();
            } else
            {
                Response.StatusCode = 404;
                Server.Transfer("/Error/404.aspx");
                return;
            }
            reader.Close();
            DBConnect.conn.Close();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            this.PreRender += Page_PreRender;
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            string id = Request.QueryString["Id"];
            if (string.IsNullOrEmpty(id))
            {
                Response.StatusCode = 404;
                Server.Transfer("/Error/404.aspx");
                return;
            }
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("UPDATE Addresses SET Label = @Label, ReceiverName = @ReceiverName, ReceiverContact = @ReceiverContact, Address = @Address, City = @City, PostalCode = @PostalCode, State = @State WHERE Id = @Id AND CustomerId = @CustomerId", conn);
            cmd.Parameters.AddWithValue("@Label", txtTitle.Text.Trim());
            cmd.Parameters.AddWithValue("@ReceiverName", txtName.Text.Trim());
            cmd.Parameters.AddWithValue("@ReceiverContact", txtContact.Text.Trim());
            cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
            cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue.Trim());
            cmd.Parameters.AddWithValue("@PostalCode", ddlPostalCode.SelectedValue.Trim());
            cmd.Parameters.AddWithValue("@State", ddlState.SelectedValue.Trim());
            cmd.Parameters.AddWithValue("@Id", id);
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
            conn.Close();
        }
    }
}