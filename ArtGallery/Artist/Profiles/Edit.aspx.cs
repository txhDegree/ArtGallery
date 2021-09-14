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
            RangeValidatorDOB.MaximumValue = DateTime.Now.Date.ToString("yyyy/MM/dd");
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            dynamic profile = ProfileBase.Create(Membership.GetUser().UserName);
            profile.Initialize(Membership.GetUser().UserName, true);
            profile.DOB = txtDOB.Text;
            profile.AboutMe = txtAbtMe.Text;

            if (FileUpload.HasFile)
            {
                string fileName = string.Empty;
                try
                {
                    fileName = Server.MapPath("~/Storage/Artist/" + Membership.GetUser().ProviderUserKey + Path.GetExtension(FileUpload.FileName));
                }
                catch
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
                    fileName = Server.MapPath("~/Storage/Artworks/" + Membership.GetUser().ProviderUserKey + Path.GetExtension(FileUpload.FileName));
                }
                finally
                {
                    FileUpload.SaveAs(fileName);
                    profile.ProfilePic = Membership.GetUser().UserName + System.IO.Path.GetExtension(FileUpload.FileName);
                }
            }
            profile.Save();
            isUpdated = true;
        }
    }
}