using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArtGallery.Customer
{
    public partial class Navbar : System.Web.UI.MasterPage
    {
        protected void Page_Init(object sender, EventArgs e) {
            username.InnerText = Membership.GetUser().UserName;
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}