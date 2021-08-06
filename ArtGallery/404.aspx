<%@ Page Title="" Language="C#" MasterPageFile="~/main.Master" AutoEventWireup="true" CodeBehind="404.aspx.cs" Inherits="ArtGallery._404" %>
<asp:Content ID="Style" ContentPlaceHolderID="MasterStyle" runat="server">
</asp:Content>
<asp:Content ID="Title" ContentPlaceHolderID="MasterTitle" runat="server">404 - Page Not Found</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <div class="container-fluid">
        <div class="text-center mt-5">
            <div class="error mx-auto" data-text="404">404</div>
            <p class="lead text-gray-800 mb-5">Page Not Found</p>
            <p class="text-gray-500 mb-0">It looks like you found a glitch in the matrix...</p>
            <a href="/login.aspx">&larr; Back to Dashboard</a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="MasterScript" runat="server">
</asp:Content>