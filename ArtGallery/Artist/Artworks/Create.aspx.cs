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
    public partial class Create : System.Web.UI.Page
    {
        protected Boolean isCreated = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            RangeValidatorYear.MaximumValue = DateTime.Now.Year.ToString();
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

            SqlCommand cmd = new SqlCommand("INSERT INTO ARTWORKS (Title, Description, Year, Price, StockQuantity, isVisible, ArtistId) OUTPUT INSERTED.Id VALUES (@title, @desc, @year, @price, @stockQty, @isVisible, @artistId)", conn);
            cmd.Parameters.AddWithValue("@title", title);
            cmd.Parameters.AddWithValue("@desc", desc);
            cmd.Parameters.AddWithValue("@year", year);
            cmd.Parameters.AddWithValue("@price", price);
            cmd.Parameters.AddWithValue("@stockQty", stock);
            cmd.Parameters.AddWithValue("@isVisible", isVisible);
            cmd.Parameters.AddWithValue("@artistId", Membership.GetUser().ProviderUserKey);
            int id = (int)cmd.ExecuteScalar();
            isCreated = id != 0;

            if (FileUpload.HasFile)
            {
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
                FileUpload.SaveAs(Server.MapPath("~/Storage/Artworks/" + id + System.IO.Path.GetExtension(FileUpload.FileName)));
                cmd = new SqlCommand("UPDATE Artworks SET Image = @Image WHERE Id = @Id AND ArtistId = @ArtistId", conn);
                cmd.Parameters.AddWithValue("@Image", id + System.IO.Path.GetExtension(FileUpload.FileName));
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.Parameters.AddWithValue("@artistId", Membership.GetUser().ProviderUserKey);
                cmd.ExecuteNonQuery();
            }

            if (isCreated)
            {
                RangeValidatorPrice.IsValid = true;
                txtTitle.Text = txtYear.Text = txtPrice.Text = txtStockQty.Text = txtDesc.Text = string.Empty;
            }

            conn.Close();
        }

        protected void CustomValidatorStockQty_ServerValidate(object source, ServerValidateEventArgs args)
        {
            int stockQty = Convert.ToInt32(args.Value);
            if(stockQty < 0)
            {
                args.IsValid = false;
                CustomValidatorStockQty.ErrorMessage = "Stock Quantity cannot be lesser than 0";
            }
        }
    }
}