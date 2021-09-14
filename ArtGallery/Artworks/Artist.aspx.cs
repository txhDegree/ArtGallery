using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Profile;
using System.Web.Security;
using System.Data.SqlClient;
using System.Configuration;

namespace ArtGallery.Artworks
{
    public partial class Artist : System.Web.UI.Page
    {
        protected Boolean isAddedToCart = false;
        protected Boolean isRemovedFromWishlist = false;
        protected Boolean unableToRemovedFromWishlist = false;
        protected Boolean isAddedToWishlist = false;
        protected Boolean isInWishlist = false;
        protected void Page_Init(object sender, EventArgs e)
        {
            MembershipUser user = Membership.GetUser();
            MembershipUser artist = Membership.GetUser(Request.QueryString["Artist"]);
            ArtworkSource.SelectParameters["CustomerId"].DefaultValue = user != null ? user.ProviderUserKey.ToString() : new Guid().ToString();
            ArtworkSource.SelectParameters["ArtistId"].DefaultValue = artist.ProviderUserKey.ToString();
            PagingSource.SelectParameters["CustomerId"].DefaultValue = ArtworkSource.SelectParameters["CustomerId"].DefaultValue;
            PagingSource.SelectParameters["ArtistId"].DefaultValue = ArtworkSource.SelectParameters["ArtistId"].DefaultValue;

            ArtworkList.AllSource = ArtworkSource;
            ArtworkList.PagingSource = PagingSource;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            dynamic profile = ProfileBase.Create(Request.QueryString["Artist"]);
            profile.Initialize(Request.QueryString["Artist"], true);
            ProfileImg.Src = string.IsNullOrEmpty(profile.ProfilePic) ? "/public/img/profile.svg" : "/Storage/Artist/" + profile.ProfilePic;
            ArtistName.InnerText = Request.QueryString["Artist"];
            abtMe.InnerText = string.IsNullOrEmpty(profile.AboutMe) ? "This artist haven't wrote anything yet..." : profile.AboutMe;
            dob.InnerText = profile.DOB;
        }
    }
}