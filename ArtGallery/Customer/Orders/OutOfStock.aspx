<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="OutOfStock.aspx.cs" Inherits="ArtGallery.Customer.Orders.OutOfStock" %>
<asp:Content ID="Content1" ContentPlaceHolderID="VendorStyle" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="title" runat="server">Payment Cancelled - Customer
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
        <div class="row">
            <div class="col-12"><h3>Out Of Stock</h3></div>
            <div class="col-12">
                <div class="alert alert-danger">Some of the product you want to purchase is out of stock, please try with lesser amount. <a href="/Customer/Carts/List.aspx" class="btn btn-danger">Back To Carts</a></div>
            </div>
            <div class="col-md-6 mx-auto"><img class="w-100" src="/public/img/cancel.svg" alt="Payment Cancel Img" /></div>
        </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="VendorScript" runat="server">
</asp:Content>
