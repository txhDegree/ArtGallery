<%@ Page Title="" Language="C#" MasterPageFile="~/main.Master" AutoEventWireup="true" CodeBehind="503.aspx.cs" Inherits="ArtGallery._503" %>
<asp:Content ID="Style" ContentPlaceHolderID="MasterStyle" runat="server">
</asp:Content>
<asp:Content ID="Title" ContentPlaceHolderID="MasterTitle" runat="server">503 - Service Unavailable</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <div class="container-fluid">
        <div class="text-center mt-5">
            <div class="error mx-auto" data-text="503">503</div>
            <p class="lead text-gray-800 mb-5">Service Unavailable</p>
            <p class="text-gray-500 mb-0">Sorry... Something went wrong to the server, please contact the system admin.</p>
            <a href="/index.aspx">&larr; Back to Dashboard</a>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="MasterScript" runat="server">
</asp:Content>