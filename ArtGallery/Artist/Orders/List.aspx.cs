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
    public partial class List : System.Web.UI.Page
    {
        protected int page = 1;
        protected void Page_Init(object sender, EventArgs e)
        {
            ArtworkSource.SelectParameters["ArtistId"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
            PagingSource.SelectParameters["ArtistId"].DefaultValue = ArtworkSource.SelectParameters["ArtistId"].DefaultValue;
            
            Pagination.initialize(ArtworkSource, PagingSource, 12);
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Repeater1_PreRender(object sender, EventArgs e)
        {
            if (Repeater1.Items.Count < 1)
            {
                NoRecords.Visible = true;
                Repeater1.Visible = false;
                Pagination.Visible = false;
            }
        }
    }
}