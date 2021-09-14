<%@ Page Title="" Language="C#" MasterPageFile="~/Artworks/Navbar.master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ArtGallery.Customer.Artworks.List" %>
<%@ Register Src="~/Controls/ArtworkList.ascx" TagPrefix="UC" TagName="Artworks" %>
<asp:Content ID="style" ContentPlaceHolderID="Style" runat="server"></asp:Content>
<asp:Content ID="title" ContentPlaceHolderID="Title" runat="server">Art Galleries</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="h3 mb-4 text-gray-800">Arts Galleries</h1>
    <UC:Artworks runat="server" ID="ArtworkList" />
    <asp:SqlDataSource ID="ArtworkSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT *, U.UserName as ArtistName, CASE WHEN [W].[CustomerId] IS NULL THEN 0 ELSE 1 END AS IsAdded FROM [Artworks] A LEFT JOIN aspnet_Users U ON A.ArtistId = U.UserId LEFT JOIN (SELECT * FROM [Wishlists] WHERE [CustomerId] = @CustomerId) W ON [A].[Id] = [W].[ArtworkId] WHERE ([A].[isVisible] = 1) ORDER BY Id DESC;">
        <SelectParameters>
            <asp:Parameter Name="CustomerId" Type="String"/>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="PagingSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT *, U.UserName as ArtistName, CASE WHEN [W].[CustomerId] IS NULL THEN 0 ELSE 1 END AS IsAdded FROM [Artworks] A LEFT JOIN aspnet_Users U ON A.ArtistId = U.UserId LEFT JOIN (SELECT * FROM [Wishlists] WHERE [CustomerId] = @CustomerId) W ON [A].[Id] = [W].[ArtworkId] WHERE ([A].[isVisible] = 1) ORDER BY Id DESC OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY;">
        <SelectParameters>
            <asp:Parameter Name="Skip" Type="Int32" DefaultValue="0"/>
            <asp:Parameter Name="Take" Type="Int32" DefaultValue="12"/>
            <asp:Parameter Name="CustomerId" Type="String"/>
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>