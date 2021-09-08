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

            Pagination.TotalRecord = ((System.Data.DataView)ArtistArtworkSource.Select(DataSourceSelectArguments.Empty)).Count;
            Pagination.RecordPerPage =12;
            Pagination.TotalPage = Convert.ToInt32(Math.Ceiling((double)Pagination.TotalRecord / Pagination.RecordPerPage));
            
            page = Request.QueryString["page"] == null ? 1 : Convert.ToInt32(Request.QueryString["page"]);
            if (page > Pagination.TotalPage)
                page = 1;
            Pagination.CurrentPage = page;
            
            PagingSource.SelectParameters["Skip"].DefaultValue = ((page-1) * Pagination.RecordPerPage).ToString();
            PagingSource.SelectParameters["Take"].DefaultValue = Pagination.RecordPerPage.ToString();
            if (Pagination.TotalPage <= 1)
                Pagination.Visible = false;

            String TempUrl = Request.FilePath + "?";
            foreach (String key in Request.QueryString.AllKeys)
            {
                if (key != "page")
                    TempUrl += key + "=" + Request.QueryString[key] + "&";
            }
            Pagination.RedirectUrl = TempUrl;
            Pagination.CurrentRecord = ((System.Data.DataView)PagingSource.Select(DataSourceSelectArguments.Empty)).Count;
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
            } else {
                
            }
        }
    }
}