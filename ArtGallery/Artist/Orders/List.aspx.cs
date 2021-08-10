﻿using System;
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
        protected void Page_Init(object sender, EventArgs e)
        {
            ArtworkSource.SelectParameters["ArtistId"].DefaultValue = Membership.GetUser().ProviderUserKey.ToString();
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}