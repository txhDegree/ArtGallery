using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
namespace ArtGallery.Email
{
    public class Mail
    {
        public static void sendPaymentSuccessEmail(string paymentId, string orderIds, string url, string email, string filepath)
        {
            //Fetching Settings from WEB.CONFIG file.  
            string emailSender = ConfigurationManager.AppSettings["username"].ToString();
            string emailSenderPassword = ConfigurationManager.AppSettings["password"].ToString();
            string emailSenderHost = ConfigurationManager.AppSettings["smtp"].ToString();
            int emailSenderPort = Convert.ToInt16(ConfigurationManager.AppSettings["portnumber"]);
            Boolean emailIsSSL = Convert.ToBoolean(ConfigurationManager.AppSettings["IsSSL"]);


            //Fetching Email Body Text from EmailTemplate File.  
            StreamReader str = new StreamReader(filepath);
            string MailText = str.ReadToEnd();
            str.Close();

            //Repalce Content
            MailText = MailText.Replace("[PaymentId]", "#"+paymentId);
            MailText = MailText.Replace("[OrderId]", orderIds);
            MailText = MailText.Replace("[CustomerOrderLink1]", url);
            MailText = MailText.Replace("[CustomerOrderLink2]", url);

            //Base class for sending email  
            MailMessage _mailmsg = new MailMessage();

            //Make TRUE because our body text is html  
            _mailmsg.IsBodyHtml = true;

            //Set From Email ID  
            _mailmsg.From = new MailAddress(emailSender);

            //Set To Email ID  
            //_mailmsg.To.Add(txtUserName.Text.ToString());
            _mailmsg.To.Add(email);

            //Set Subject  
            _mailmsg.Subject = "Art Gallery - Payment Success! #" + paymentId;

            //Set Body Text of Email   
            _mailmsg.Body = MailText;


            //Now set your SMTP   
            SmtpClient _smtp = new SmtpClient();

            //Set HOST server SMTP detail  
            _smtp.Host = emailSenderHost;

            //Set PORT number of SMTP  
            _smtp.Port = emailSenderPort;

            //Set SSL --> True / False  
            _smtp.EnableSsl = emailIsSSL;

            //Set Sender UserEmailID, Password  
            NetworkCredential _network = new NetworkCredential(emailSender, emailSenderPassword);
            _smtp.Credentials = _network;

            //Send Method will send your MailMessage create above.  
            _smtp.Send(_mailmsg);
        }

        public static void sendShippedEmail(string orderId, string trackingNo, string orderPageUrl, string email, string filepath)
        {
            //Fetching Settings from WEB.CONFIG file.  
            string emailSender = ConfigurationManager.AppSettings["username"].ToString();
            string emailSenderPassword = ConfigurationManager.AppSettings["password"].ToString();
            string emailSenderHost = ConfigurationManager.AppSettings["smtp"].ToString();
            int emailSenderPort = Convert.ToInt16(ConfigurationManager.AppSettings["portnumber"]);
            Boolean emailIsSSL = Convert.ToBoolean(ConfigurationManager.AppSettings["IsSSL"]);


            //Fetching Email Body Text from EmailTemplate File.  
            StreamReader str = new StreamReader(filepath);
            string MailText = str.ReadToEnd();
            str.Close();

            //Repalce Content
            MailText = MailText.Replace("[OrderId]", "#"+orderId);
            MailText = MailText.Replace("[TrackingNo]", "#" + trackingNo);
            
            MailText = MailText.Replace("[CustomerOrderLink1]", orderPageUrl);
            MailText = MailText.Replace("[CustomerOrderLink2]", orderPageUrl);

            MailText = MailText.Replace("[TrackingLink1]", "https://www.tracking.my/track/" + trackingNo);
            MailText = MailText.Replace("[TrackingLink2]", "https://www.tracking.my/track/" + trackingNo);

            //Base class for sending email  
            MailMessage _mailmsg = new MailMessage();

            //Make TRUE because our body text is html  
            _mailmsg.IsBodyHtml = true;

            //Set From Email ID  
            _mailmsg.From = new MailAddress(emailSender);

            //Set To Email ID  
            //_mailmsg.To.Add(txtUserName.Text.ToString());
            _mailmsg.To.Add(email);

            //Set Subject  
            _mailmsg.Subject = "Art Gallery - Your order has been shipped! #" + orderId;

            //Set Body Text of Email   
            _mailmsg.Body = MailText;


            //Now set your SMTP   
            SmtpClient _smtp = new SmtpClient();

            //Set HOST server SMTP detail  
            _smtp.Host = emailSenderHost;

            //Set PORT number of SMTP  
            _smtp.Port = emailSenderPort;

            //Set SSL --> True / False  
            _smtp.EnableSsl = emailIsSSL;

            //Set Sender UserEmailID, Password  
            NetworkCredential _network = new NetworkCredential(emailSender, emailSenderPassword);
            _smtp.Credentials = _network;

            //Send Method will send your MailMessage create above.  
            _smtp.Send(_mailmsg);
        }
    }
}