using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using System.Data.SqlClient;

namespace ArtGallery.Customer.Artworks
{
    public partial class List : System.Web.UI.Page
    {

        protected Boolean isAddedToCart = false;
        protected Boolean isRemovedFromWishlist = false;
        protected Boolean unableToRemovedFromWishlist = false;
        protected Boolean isAddedToWishlist = false;
        protected Boolean isInWishlist = false;
        protected void Page_Init(object sender, EventArgs e)
        {
            MembershipUser user = Membership.GetUser();
            ArtworkSource.SelectParameters["CustomerId"].DefaultValue = user != null ? user.ProviderUserKey.ToString() : new Guid().ToString();
            PagingSource.SelectParameters["CustomerId"].DefaultValue = ArtworkSource.SelectParameters["CustomerId"].DefaultValue;

            ArtworkList.AllSource = ArtworkSource;
            ArtworkList.PagingSource = PagingSource;
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}