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
    public partial class Edit : System.Web.UI.Page
    {
        protected Boolean isUpdated = false;

        protected void Page_PreRender(object sender, EventArgs e) {
            if (!(isUpdated || !IsPostBack))
                return;
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            SqlCommand cmd;
            conn.Open();
            string id = Request.QueryString["Id"];
            cmd = new SqlCommand("SELECT * FROM Artworks WHERE ArtistId = @ArtistId AND Id = @Id", conn);
            cmd.Parameters.AddWithValue("@ArtistId", Membership.GetUser().ProviderUserKey);
            cmd.Parameters.AddWithValue("@Id", id);
            SqlDataReader reader = cmd.ExecuteReader();
            if (!reader.HasRows)
            {
                throw new HttpException(404, "Not found");
            }
            reader.Read();
            txtId.Text = "#" + reader["Id"].ToString();
            txtTitle.Text = reader["Title"].ToString();
            txtYear.Text = Convert.ToDateTime(reader["Year"].ToString()).Year.ToString();
            txtPrice.Text = ((Decimal)reader["Price"]).ToString("F");
            txtStockQty.Text = reader["StockQuantity"].ToString();
            txtDesc.Text = reader["Description"].ToString();
            cIsVisible.Checked = reader["isVisible"].ToString() == "1";
            reader.Close();
            conn.Close();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.PreRender += Page_PreRender;
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ArtDBConnStr"].ConnectionString);
            SqlCommand cmd;
            conn.Open();
            string title = txtTitle.Text;
            string year = txtYear.Text;
            double price = Convert.ToDouble(txtPrice.Text);
            int stock = Convert.ToInt32(txtStockQty.Text);
            string desc = txtDesc.Text;
            int isVisible = cIsVisible.Checked ? 1 : 0;

            cmd = new SqlCommand("UPDATE Artworks SET Title=@title, Description=@desc, Year=@year, Price=@price, StockQuantity=@stockQty, isVisible=@isVisible WHERE Id=@id AND ArtistId=@artistId", conn);
            cmd.Parameters.AddWithValue("@title", title);
            cmd.Parameters.AddWithValue("@desc", desc);
            cmd.Parameters.AddWithValue("@year", year);
            cmd.Parameters.AddWithValue("@price", price);
            cmd.Parameters.AddWithValue("@stockQty", stock);
            cmd.Parameters.AddWithValue("@isVisible", isVisible);
            cmd.Parameters.AddWithValue("@id", Request.QueryString["Id"]);
            cmd.Parameters.AddWithValue("@artistId", Membership.GetUser().ProviderUserKey);
            isUpdated = cmd.ExecuteNonQuery() > 0;
            conn.Close();
        }
    }
}