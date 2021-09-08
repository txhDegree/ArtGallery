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