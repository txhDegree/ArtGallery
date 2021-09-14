using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using System.Data.SqlClient;

namespace ArtGallery.Customer.Artworks
{
    public partial class List : System.Web.UI.Page
    {

        protected Boolean isAddedToCart = false;
        protected Boolean isRemovedFromWishlist = false;
        protected Boolean unableToRemovedFromWishlist = false;
        protected Boolean isAddedToWishlist = false;
        protected Boolean isInWishlist = false;
        protected void Page_Init(object sender, EventArgs e)
        {
            MembershipUser user = Membership.GetUser();
            ArtworkSource.SelectParameters["CustomerId"].DefaultValue = user != null ? user.ProviderUserKey.ToString() : new Guid().ToString();
            PagingSource.SelectParameters["CustomerId"].DefaultValue = ArtworkSource.SelectParameters["CustomerId"].DefaultValue;

            ArtworkList.AllSource = ArtworkSource;
            ArtworkList.PagingSource = PagingSource;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            ArtworkList.Reload();
        }

        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string fromStr = price_from.Text, toStr = price_to.Text;
            double from = 0, to = 0;
            if (!string.IsNullOrEmpty(fromStr))
            {
                try
                {
                    from = Convert.ToDouble(fromStr);
                } catch (FormatException ex)
                {
                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = "Invalid Price Format at 'Price From'";
                    return;
                }
                if(from < 0)
                {
                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = "'Price From' cannot be a negative number";
                    return;
                }
            }
            if (!string.IsNullOrEmpty(toStr))
            {
                try
                {
                    to = Convert.ToDouble(toStr);
                }
                catch (FormatException ex)
                {
                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = "Invalid Price Format at 'Price To'";
                    return;
                }
                if (to < 0)
                {
                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = "'Price To' cannot be a negative number";
                    return;
                }
            }
            
            if(!string.IsNullOrEmpty(fromStr) && !string.IsNullOrEmpty(toStr))
            {
                if(from > to)
                {
                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = "'Price From' cannot be greater than 'Price To'";
                    return;
                }
            }
        }
    }
}