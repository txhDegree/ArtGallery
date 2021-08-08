<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="NewOrder.aspx.cs" Inherits="ArtGallery.Customer.Orders.NewOrder" %>
<asp:Content ID="style" ContentPlaceHolderID="VendorStyle" runat="server">
</asp:Content>
<asp:Content ID="title" ContentPlaceHolderID="title" runat="server">New Order - Customer</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">Create New Order</h1>
    <div class="row">
        <div class="col-12">
            <div class="alert alert-success">Your orders have been created successfully! to make payment for all unpaid orders, click the button below.</div>
        </div>
    </div>
</asp:Content>
<asp:Content ContentPlaceHolderID="VendorScript" runat="server"></asp:Content>