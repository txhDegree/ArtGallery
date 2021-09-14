using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Web.UI.WebControls;

namespace ArtGallery
{
    public partial class index : System.Web.UI.Page
    {
        protected Boolean isLoggedIn = false;
        protected string role = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            MembershipUser user = Membership.GetUser();
            if (user != null)
            {
                isLoggedIn = true;
                role = Roles.GetRolesForUser(user.UserName)[0];
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