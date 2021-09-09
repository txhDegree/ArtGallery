using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArtGallery.Artist.Artworks
{
    public partial class List : System.Web.UI.Page
    {
        protected int page = 1;
        protected void Page_Init(object sender, EventArgs e)
        {
            ArtistArtworkSource.SelectParameters["ArtistId"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
            PagingSource.SelectParameters["ArtistId"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();

            Pagination.initialize(ArtistArtworkSource, PagingSource, 12);
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