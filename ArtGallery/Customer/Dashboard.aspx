<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="ArtGallery.Customer.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="VendorStyle" runat="server">
    <style>
.main {
    padding-top: 10.5rem;
    padding-bottom: 6rem;
    text-align: center;
    color: #fff;
    background-image: url("/public/img/landing-bg.jpg");
    background-repeat: no-repeat;
    background-attachment: scroll;
    background-position: center center;
    background-size: cover;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="title" runat="server">Customer Dashboard</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
    <div class="main">
        <h1>Welcome to Customer Dashboard!</h1>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="VendorScript" runat="server">
</asp:Content>