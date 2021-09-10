<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="PaymentSuccess.aspx.cs" Inherits="ArtGallery.Customer.Payments.PaymentSuccess" %>
<asp:Content ID="Content2" ContentPlaceHolderID="title" runat="server">Payment Success! - Customer</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
    <div class="row">
        <div class="col-12"><h3>Payment Success!</h3></div>
        <div class="col-12 my-2">
            <div class="alert alert-success">Your payment is completed, the Artists will prepare your order soon! <a class="btn btn-success" href="/Customer/Orders/List.aspx">Go To Order List</a></div>
        </div>
        <div class="col-md-6 mx-auto"><img class="w-100" src="/public/img/payment_success.svg" alt="Payment Success Img" /></div>
    </div>
</asp:Content>