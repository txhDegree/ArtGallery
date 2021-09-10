using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.Profile;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArtGallery.Artist
{
    public partial class Navbar : System.Web.UI.MasterPage
    {
        protected string ProfilePic = "/public/img/profile.svg";
        protected void Page_Init(object sender, EventArgs e)
        {
            username.InnerText = Membership.GetUser().UserName;
            dynamic profile = ProfileBase.Create(Membership.GetUser().UserName);
            profile.Initialize(Membership.GetUser().UserName, true);
            if (!string.IsNullOrEmpty(profile.ProfilePic))
            {
                ProfilePic = "/Storage/Artist/" + profile.ProfilePic;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Logout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Response.Redirect("/index.aspx");
        }
    }
}