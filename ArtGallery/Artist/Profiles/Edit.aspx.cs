using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Web.Profile;
using System.IO;

namespace ArtGallery.Artist.Profiles
{
    public partial class Edit : System.Web.UI.Page
    {
        protected Boolean isUpdated = false;
        protected String ImgSrc = "/public/img/profile.svg";
        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (!(isUpdated || !IsPostBack))
                return;

            dynamic profile = ProfileBase.Create(Membership.GetUser().UserName);
            profile.Initialize(Membership.GetUser().UserName, true);
            txtDOB.Text = profile.DOB;
            txtAbtMe.Text = profile.AboutMe;
            if(!string.IsNullOrEmpty(profile.ProfilePic)) 
            {
                ImgSrc = "/Storage/Artist/" + profile.ProfilePic;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.PreRender += Page_PreRender;
            RangeValidatorDOB.MaximumValue = DateTime.Now.Date.ToString("MM/dd/yyyy");
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            string dob = txtDOB.Text;
            string amtMe = txtAbtMe.Text;
            dynamic profile = ProfileBase.Create(Membership.GetUser().UserName);
            profile.Initialize(Membership.GetUser().UserName, true);
            profile.DOB = dob;
            profile.AboutMe = amtMe;

            if (FileUpload.HasFile)
            {
                var StoragePath = Server.MapPath("~/Storage/");
                if (!Directory.Exists(StoragePath))
                {
                    Directory.CreateDirectory(StoragePath);
                }
                var ArtistPath = Server.MapPath("~/Storage/Artist/");
                if (!Directory.Exists(ArtistPath))
                {
                    Directory.CreateDirectory(ArtistPath);
                }
                FileUpload.SaveAs(Server.MapPath("~/Storage/Artist/" + Membership.GetUser().UserName + System.IO.Path.GetExtension(FileUpload.FileName)));
                profile.ProfilePic = Membership.GetUser().UserName + System.IO.Path.GetExtension(FileUpload.FileName);
            }
            profile.Save();

            isUpdated = true;
        }
    }
}