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
    public partial class Create : System.Web.UI.Page
    {
        protected Boolean isCreated = false;
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();

            SqlCommand cmd = new SqlCommand("INSERT INTO Addresses (Label, ReceiverName, ReceiverContact, Address, City, PostalCode, State, CustomerId) VALUES (@Label, @ReceiverName, @ReceiverContact, @Address, @City, @PostalCode, @State, @CustomerId)", conn);
            cmd.Parameters.AddWithValue("@Label", txtTitle.Text.Trim());
            cmd.Parameters.AddWithValue("@ReceiverName", txtName.Text.Trim());
            cmd.Parameters.AddWithValue("@ReceiverContact", txtContact.Text.Trim());
            cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
            cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue.Trim());
            cmd.Parameters.AddWithValue("@PostalCode", ddlPostalCode.SelectedValue.Trim());
            cmd.Parameters.AddWithValue("@State", ddlState.SelectedValue.Trim());
            cmd.Parameters.AddWithValue("@CustomerId", Membership.GetUser().ProviderUserKey);

            isCreated = cmd.ExecuteNonQuery() > 0;

            if (isCreated)
            {
                txtTitle.Text = txtName.Text = txtContact.Text = txtAddress.Text = string.Empty;
            }

            conn.Close();
        }
    }
}