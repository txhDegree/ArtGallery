<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="MakePayment.aspx.cs" Inherits="ArtGallery.Customer.Payments.MakePayment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="VendorStyle" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="title" runat="server">Payment Process - Customer
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
    <div class="row">
        <div class="col-12">
            <div class="alert alert-info">
                Please wait... redirecting you to payment page... If you are not redirected, <button id="checkoutBtn" class="btn btn-primary">Click Here</button>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="VendorScript" runat="server">
    <script src="https://js.stripe.com/v3/"></script>
    <script>
        var stripe = Stripe('pk_test_51JM6faCafuyPLxsgpjLErLfdrMTksEI8c8tS8TB62NSxMzQ0R0MEVUz8aJ4dkqNRS1QoEQpiUy3b0KOzFSOKfxrG00tpuhwI6j');
        const btn = document.getElementById('checkoutBtn')
        btn, addEventListener('click', (e) => {
            e.preventDefault();
            stripe.redirectToCheckout({
                sessionId: "<%= sessionId %>"
            });
        })
        stripe.redirectToCheckout({
            sessionId: "<%= sessionId %>"
        });
    </script>
</asp:Content>
