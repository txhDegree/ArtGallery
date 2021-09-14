using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.IO;

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
            RangeValidatorYear.MaximumValue = DateTime.Now.Year.ToString();
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
            
            if(FileUpload.HasFile) {
                var StoragePath = Server.MapPath("~/Storage/");
                if (!Directory.Exists(StoragePath))
                {
                    Directory.CreateDirectory(StoragePath);
                }
                var ArtworkPath = Server.MapPath("~/Storage/Artworks/");
                if (!Directory.Exists(ArtworkPath))
                {
                    Directory.CreateDirectory(ArtworkPath);
                }
                FileUpload.SaveAs(Server.MapPath("~/Storage/Artworks/" + Request.QueryString["Id"] + System.IO.Path.GetExtension(FileUpload.FileName)));
                cmd = new SqlCommand("UPDATE Artworks SET Image = @Image WHERE Id = @Id AND ArtistId = @ArtistId",conn);
                cmd.Parameters.AddWithValue("@Image", Request.QueryString["Id"] + System.IO.Path.GetExtension(FileUpload.FileName));
                cmd.Parameters.AddWithValue("@Id", Request.QueryString["Id"]);
                cmd.Parameters.AddWithValue("@artistId", Membership.GetUser().ProviderUserKey);
                cmd.ExecuteNonQuery();
            }

            conn.Close();
        }

        protected void CustomValidatorStockQty_ServerValidate(object source, ServerValidateEventArgs args)
        {
            int stockQty = Convert.ToInt32(args.Value);
            if (stockQty < 0)
            {
                args.IsValid = false;
                CustomValidatorStockQty.ErrorMessage = "Stock Quantity cannot be lesser than 0";
            }
        }
    }
}