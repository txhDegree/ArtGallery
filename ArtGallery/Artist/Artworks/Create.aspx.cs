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
            double price = 0;
            int stock = 0;
            try
            {
                price = Convert.ToDouble(txtPrice.Text);
            } catch (FormatException ex)
            {
                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = "Invalid format for price";
                return;
            }
            try
            {
                stock = Convert.ToInt32(txtStockQty.Text);
            }
            catch (FormatException ex)
            {
                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = "Invalid format for stock quantity";
                return;
            }

            string title = txtTitle.Text;
            string year = txtYear.Text;
            string desc = txtDesc.Text;
            int isVisible = cIsVisible.Checked ? 1 : 0;

            if (!DBConnect.Open()) {
                Response.StatusCode = 503;
                Server.Transfer("/Error/503.aspx");
                return;
            }

            SqlCommand cmd = new SqlCommand("INSERT INTO ARTWORKS (Title, Description, Year, Price, StockQuantity, isVisible, ArtistId) OUTPUT INSERTED.Id VALUES (@title, @desc, @year, @price, @stockQty, @isVisible, @artistId)", DBConnect.conn);
            cmd.Parameters.AddWithValue("@title", title);
            cmd.Parameters.AddWithValue("@desc", desc);
            cmd.Parameters.AddWithValue("@year", year);
            cmd.Parameters.AddWithValue("@price", price);
            cmd.Parameters.AddWithValue("@stockQty", stock);
            cmd.Parameters.AddWithValue("@isVisible", isVisible);
            cmd.Parameters.AddWithValue("@artistId", Membership.GetUser().ProviderUserKey);
            int id = 0;
            try
            {
                id = Convert.ToInt32(cmd.ExecuteScalar());
            } catch
            {
                isCreated = false;
                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = "Unable to create artwork.";
                DBConnect.conn.Close();
                return;
            }

            isCreated = id != 0;

            if (FileUpload.HasFile)
            {
                string fileName = string.Empty;
                try
                {
                    fileName = Server.MapPath("~/Storage/Artworks/" + id + Path.GetExtension(FileUpload.FileName));
                    FileUpload.SaveAs(fileName);
                } catch
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
                    fileName = Server.MapPath("~/Storage/Artworks/" + id + Path.GetExtension(FileUpload.FileName));
                    FileUpload.SaveAs(fileName);
                }
                finally
                {
                    cmd = new SqlCommand("UPDATE Artworks SET Image = @Image WHERE Id = @Id AND ArtistId = @ArtistId", DBConnect.conn);
                    cmd.Parameters.AddWithValue("@Image", id + Path.GetExtension(FileUpload.FileName));
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.Parameters.AddWithValue("@artistId", Membership.GetUser().ProviderUserKey);
                    cmd.ExecuteNonQuery();
                }
            }

            if (isCreated)
            {
                RangeValidatorPrice.IsValid = true;
                txtTitle.Text = txtYear.Text = txtPrice.Text = txtStockQty.Text = txtDesc.Text = string.Empty;
            }

            DBConnect.conn.Close();
        }

        protected void CustomValidatorStockQty_ServerValidate(object source, ServerValidateEventArgs args)
        {
            try
            {
                int stockQty = Convert.ToInt32(args.Value);
                if(stockQty < 0)
                {
                    args.IsValid = false;
                    CustomValidatorStockQty.ErrorMessage = "Stock Quantity cannot be lesser than 0";
                }
            } catch
            {
                args.IsValid = false;
                CustomValidatorStockQty.ErrorMessage = "Invalid format for Stock Quantity";
            }
        }
    }
}