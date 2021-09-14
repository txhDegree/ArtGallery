<%@ Page Title="" Language="C#" MasterPageFile="~/main.Master" AutoEventWireup="true" CodeBehind="500.aspx.cs" Inherits="ArtGallery._500" %>
<asp:Content ID="Style" ContentPlaceHolderID="MasterStyle" runat="server">
</asp:Content>
<asp:Content ID="Title" ContentPlaceHolderID="MasterTitle" runat="server">500 - Internal Server Error</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <div class="container-fluid">
        <div class="text-center mt-5">
            <div class="error mx-auto" data-text="500">500</div>
            <p class="lead text-gray-800 mb-5">Internal Server Error</p>
            <p class="text-gray-500 mb-0">Sorry... Something went wrong to the server, please contact the system admin.</p>
            <a href="/index.aspx">&larr; Back to Dashboard</a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="MasterScript" runat="server">
</asp:Content>