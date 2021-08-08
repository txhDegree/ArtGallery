using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;

namespace ArtGallery.Artist.Artworks
{
    public partial class Create : System.Web.UI.Page
    {
        protected Boolean isCreated = false;
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            string title = txtTitle.Text;
            string year = txtYear.Text;
            double price = Convert.ToDouble(txtPrice.Text);
            int stock = Convert.ToInt32(txtStockQty.Text);
            string desc = txtDesc.Text;
            int isVisible = cIsVisible.Checked ? 1 : 0;

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            conn.Open();

            SqlCommand cmd = new SqlCommand("INSERT INTO ARTWORKS (Title, Description, Year, Price, StockQuantity, isVisible, ArtistId) VALUES (@title, @desc, @year, @price, @stockQty, @isVisible, @artistId)", conn);
            cmd.Parameters.AddWithValue("@title", title);
            cmd.Parameters.AddWithValue("@desc", desc);
            cmd.Parameters.AddWithValue("@year", year);
            cmd.Parameters.AddWithValue("@price", price);
            cmd.Parameters.AddWithValue("@stockQty", stock);
            cmd.Parameters.AddWithValue("@isVisible", isVisible);
            cmd.Parameters.AddWithValue("@artistId", Membership.GetUser().ProviderUserKey);

            isCreated = cmd.ExecuteNonQuery() > 0;

            if (isCreated)
            {
                txtTitle.Text = txtYear.Text = txtPrice.Text = txtStockQty.Text = txtDesc.Text = string.Empty;
            }

            conn.Close();
        }
    }
}