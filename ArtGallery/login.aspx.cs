using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

namespace ArtGallery.Artist
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Login1_LoggedIn(object sender, EventArgs e)
        {
            switch (Roles.GetRolesForUser(Login1.UserName)[0]) {
                case "Customer":
                    if (Request.QueryString["ReturnUrl"] != null)
                        Response.Redirect(Request.QueryString["ReturnUrl"]);
                    else
                        Response.Redirect("/Customer/Carts/List.aspx");
                    break;
                case "Artist":
                    if (Request.QueryString["ReturnUrl"] != null)
                        Response.Redirect(Request.QueryString["ReturnUrl"]);
                    else
                        Response.Redirect("/Artist/Artworks/List.aspx");
                    break;
            }
        }
    }
}