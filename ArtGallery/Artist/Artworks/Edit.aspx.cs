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
            if (!DBConnect.Open())
            {
                Response.StatusCode = 503;
                Server.Transfer("/Error/503.aspx");
                return;
            }
            string id = Request.QueryString["Id"];
            if (string.IsNullOrEmpty(id))
            {
                Response.StatusCode = 404;
                Server.Transfer("/Error/404.aspx");
                return;
            }
            SqlCommand cmd = new SqlCommand("SELECT * FROM Artworks WHERE ArtistId = @ArtistId AND Id = @Id", DBConnect.conn);
            cmd.Parameters.AddWithValue("@ArtistId", Membership.GetUser().ProviderUserKey);
            cmd.Parameters.AddWithValue("@Id", id);
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
            if (!reader.Read())
            {
                Response.StatusCode = 404;
                Server.Transfer("/Error/404.aspx");
                return;
            }
            txtId.Text = "#" + reader["Id"].ToString();
            txtTitle.Text = reader["Title"].ToString();
            txtYear.Text = Convert.ToDateTime(reader["Year"].ToString()).Year.ToString();
            txtPrice.Text = Convert.ToDecimal(reader["Price"]).ToString("F");
            txtStockQty.Text = reader["StockQuantity"].ToString();
            txtDesc.Text = reader["Description"].ToString();
            cIsVisible.Checked = reader["isVisible"].ToString() == "1";
            reader.Close();
            DBConnect.conn.Close();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.PreRender += Page_PreRender;
            RangeValidatorYear.MaximumValue = DateTime.Now.Year.ToString();
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            if (!DBConnect.Open())
            {
                Response.StatusCode = 503;
                Server.Transfer("/Error/503.aspx");
                return;
            }
            string id = Request.QueryString["Id"];
            if (string.IsNullOrEmpty(id))
            {
                Response.StatusCode = 404;
                Server.Transfer("/Error/404.aspx");
                return;
            }

            double price = 0;
            int stock = 0;
            try
            {
                price = Convert.ToDouble(txtPrice.Text);
            }
            catch (FormatException ex)
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

            SqlCommand cmd = new SqlCommand("UPDATE Artworks SET Title=@title, Description=@desc, Year=@year, Price=@price, StockQuantity=@stockQty, isVisible=@isVisible WHERE Id=@id AND ArtistId=@artistId", DBConnect.conn);
            cmd.Parameters.AddWithValue("@title", title);
            cmd.Parameters.AddWithValue("@desc", desc);
            cmd.Parameters.AddWithValue("@year", year);
            cmd.Parameters.AddWithValue("@price", price);
            cmd.Parameters.AddWithValue("@stockQty", stock);
            cmd.Parameters.AddWithValue("@isVisible", isVisible);
            cmd.Parameters.AddWithValue("@id", id);
            cmd.Parameters.AddWithValue("@artistId", Membership.GetUser().ProviderUserKey);
            try
            {
                isUpdated = cmd.ExecuteNonQuery() > 0;
            } catch
            {
                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = "Fail to update artwork details";
                isUpdated = false;
                return;
            }

            if (FileUpload.HasFile)
            {
                string fileName = string.Empty;
                try
                {
                    fileName = Server.MapPath("~/Storage/Artworks/" + id + Path.GetExtension(FileUpload.FileName));
                }
                catch
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
                }
                finally
                {
                    FileUpload.SaveAs(fileName);
                    cmd = new SqlCommand("UPDATE Artworks SET Image = @Image WHERE Id = @Id AND ArtistId = @ArtistId", DBConnect.conn);
                    cmd.Parameters.AddWithValue("@Image", id + Path.GetExtension(FileUpload.FileName));
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.Parameters.AddWithValue("@artistId", Membership.GetUser().ProviderUserKey);
                    cmd.ExecuteNonQuery();
                }
            }

            DBConnect.conn.Close();
        }

        protected void CustomValidatorStockQty_ServerValidate(object source, ServerValidateEventArgs args)
        {
            try
            {
                int stockQty = Convert.ToInt32(args.Value);
                if (stockQty < 0)
                {
                    args.IsValid = false;
                    CustomValidatorStockQty.ErrorMessage = "Stock Quantity cannot be lesser than 0";
                }
            }
            catch
            {
                args.IsValid = false;
                CustomValidatorStockQty.ErrorMessage = "Invalid format for Stock Quantity";
            }
        }
    }
}