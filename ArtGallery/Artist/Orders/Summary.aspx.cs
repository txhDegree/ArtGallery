using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArtGallery.Artist.Orders
{
    public partial class Summary : System.Web.UI.Page
    {
        protected int month;
        protected int year;
        protected double totalAmount;
        protected Dictionary<int, Double> collection = new Dictionary<int, Double>();
        protected void Page_Init(object sender, EventArgs e)
        {
            string monthStr = Request.QueryString["month"], yearStr = Request.QueryString["year"];
            if( string.IsNullOrEmpty(monthStr))
            {
                month = DateTime.Now.Month;
            } else
            {
                try
                {
                    month = Convert.ToInt32(monthStr);
                    if(month > 12 || month < 1)
                    {
                        month = DateTime.Now.Month;
                    }
                } catch (FormatException ex)
                {
                    month = DateTime.Now.Month;
                }
            }

            if (string.IsNullOrEmpty(yearStr))
            {
                year = DateTime.Now.Year;
            }
            else
            {
                try
                {
                    year = Convert.ToInt32(yearStr);
                }
                catch (FormatException ex)
                {
                    year = DateTime.Now.Year;
                }
            }
            ddlYear.SelectedValue = year.ToString();
            ddlMonth.SelectedValue = month.ToString();
            if (year == DateTime.Now.Year)
            {
                for(int i = DateTime.Now.Month + 1; i <= 12; i++)
                {
                    ddlMonth.Items.Remove(new ListItem(i.ToString()));
                }
            }

            int MaxDay;
            if(year == DateTime.Now.Year && month == DateTime.Now.Month)
            {
                string dayStr = DateTime.Now.Date.ToString("dd");
                MaxDay = Convert.ToInt32(dayStr);
            } else
            {
                MaxDay = DateTime.DaysInMonth(year, month);
            }

            MembershipUser user = Membership.GetUser();
            DBConnect.Open();
            SqlCommand cmd = new SqlCommand("SELECT DAY([Date]) as datestr, SUM(TotalAmount) as subtotal FROM Orders WHERE ArtistId = @ArtistId AND MONTH([Date]) = @Month AND YEAR([Date]) = @Year GROUP BY DAY([Date])", DBConnect.conn);
            cmd.Parameters.AddWithValue("@ArtistId", user.ProviderUserKey);
            cmd.Parameters.AddWithValue("@Month", month);
            cmd.Parameters.AddWithValue("@Year", year);
            SqlDataReader reader = cmd.ExecuteReader();

            for(int i = 1; i <= MaxDay; i++)
            {
                collection.Add(i,0);
            }

            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    int day = Convert.ToInt32(reader["datestr"]);
                    double subtotal = Convert.ToDouble(reader["subtotal"]);
                    collection[day] = subtotal;
                    totalAmount += subtotal;
                }
                reader.Close();
            }
            DBConnect.conn.Close();
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ddlMonth_Init(object sender, EventArgs e)
        {
            for (int i = 1; i <= 12; i++)
            {
                ddlMonth.Items.Add(new ListItem(i.ToString()));
            }
        }

        protected void ddlYear_Init(object sender, EventArgs e)
        {
            for (int i = DateTime.Now.Year; i >= 2021; i--)
            {
                ddlYear.Items.Add(new ListItem(i.ToString()));
            }
        }

        protected void checkYear_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Artist/Orders/Summary.aspx?month=" + ddlMonth.SelectedValue + "&year=" + ddlYear.SelectedValue);
        }
    }
}