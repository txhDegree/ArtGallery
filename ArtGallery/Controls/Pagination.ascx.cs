using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArtGallery.Controls
{

    public partial class Pagination : System.Web.UI.UserControl
    {
        public int RecordPerPage { get; set; }
        public int CurrentRecord { get; set; }
        public int TotalRecord{ get; set; }
        public int TotalPage { get; set; }
        public int CurrentPage { get; set; }
        public int StartingPage {get;set;}
        public int EndingPage { get; set; }
        public String RedirectUrl { get; set; }

        public void initialize(SqlDataSource AllSource, SqlDataSource PagingSource, int PerPage)
        {
            // Get TotalRecord
            System.Data.DataView allDataView = (System.Data.DataView)AllSource.Select(DataSourceSelectArguments.Empty);
            TotalRecord = allDataView == null ? 0 : allDataView.Count;
            
            // Set RecordPerPage
            RecordPerPage = PerPage;

            // Find TotalPage
            TotalPage = Convert.ToInt32(Math.Ceiling((double)TotalRecord / RecordPerPage));

            // If TotalPage is less than equal 1, then no need to display
            Visible = !(TotalPage <= 1);

            // Find CurrentPage from QueryString, if current page is more than total page, set to 1
            CurrentPage = Request.QueryString["page"] == null ? 1 : Convert.ToInt32(Request.QueryString["page"]);
            if (CurrentPage > TotalPage)
                CurrentPage = 1;

            // Construct Redirect URL for Paging
            String TempUrl = Request.FilePath + "?";
            foreach (String key in Request.QueryString.AllKeys)
            {
                if (key != "page")
                    TempUrl += key + "=" + Request.QueryString[key] + "&";
            }
            RedirectUrl = TempUrl;
            
            // Find the current number of record showing
            PagingSource.SelectParameters["Skip"].DefaultValue = ((CurrentPage - 1) * RecordPerPage).ToString();
            PagingSource.SelectParameters["Take"].DefaultValue = RecordPerPage.ToString();
            System.Data.DataView dataView = (System.Data.DataView)PagingSource.Select(DataSourceSelectArguments.Empty);
            CurrentRecord = dataView == null ? 0 : dataView.Count;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if(TotalPage <= 5)
            {
                StartingPage = 1;
                EndingPage = TotalPage;
            } else if(CurrentPage - 2 < 1)
            {
                StartingPage = 1;
                EndingPage = 5;
            } else if (CurrentPage + 2 > TotalPage)
            {
                StartingPage = TotalPage - 4;
                EndingPage = TotalPage;
            } else
            {
                StartingPage = CurrentPage - 2;
                EndingPage = CurrentPage + 2;
            }
        }
    }
}