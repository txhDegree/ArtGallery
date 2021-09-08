using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArtGallery
{
    public partial class Navbar : System.Web.UI.MasterPage
    {
        protected Boolean isLoggedIn = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            MembershipUser user = Membership.GetUser();
            if(user != null)
            {
                if(Roles.GetRolesForUser(user.UserName)[0] == "Customer") {
                    isLoggedIn = true;
                }
            }
        }

        protected void logoutBtn_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("/index.aspx");
        }
    }
}