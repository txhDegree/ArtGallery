<%@ Page Title="" Language="C#" MasterPageFile="~/Artworks/Navbar.master" AutoEventWireup="true" CodeBehind="Artist.aspx.cs" Inherits="ArtGallery.Artworks.Artist" %>
<%@ Register Src="~/Controls/ArtworkList.ascx" TagPrefix="UC" TagName="Artworks" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Title" runat="server">Artist Profile</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row d-flex justify-content-center align-items-center">
        <div>
            <img src="" alt="" style="max-height: 300px; max-width: 300px;" runat="server" id="ProfileImg"  />
        </div>
    </div>
    <h2 class="text-center" runat="server" id="ArtistName"></h2>
    <p class="text-center" runat="server" id="dob"></p>
    <div class="container">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">About Me</h5>
                <p class="card-text" runat="server" id="abtMe"></p>
            </div>
        </div>
        <div class="card mt-3">
            <div class="card-body">
                <h5 class="card-title">My Artworks</h5>
                <UC:Artworks runat="server" ID="ArtworkList"/>
                <asp:SqlDataSource ID="ArtworkSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT *, U.UserName as ArtistName, CASE WHEN [W].[CustomerId] IS NULL THEN 0 ELSE 1 END AS IsAdded FROM [Artworks] A LEFT JOIN aspnet_Users U ON A.ArtistId = U.UserId LEFT JOIN (SELECT * FROM [Wishlists] WHERE [CustomerId] = @CustomerId) W ON [A].[Id] = [W].[ArtworkId] WHERE ([A].[isVisible] = 1) AND [A].[ArtistId] = @ArtistId  ORDER BY Id DESC;">
                    <SelectParameters>
                        <asp:Parameter Name="ArtistId" Type="String"/>
                        <asp:Parameter Name="CustomerId" Type="String"/>
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="PagingSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT *, U.UserName as ArtistName, CASE WHEN [W].[CustomerId] IS NULL THEN 0 ELSE 1 END AS IsAdded FROM [Artworks] A LEFT JOIN aspnet_Users U ON A.ArtistId = U.UserId LEFT JOIN (SELECT * FROM [Wishlists] WHERE [CustomerId] = @CustomerId) W ON [A].[Id] = [W].[ArtworkId] WHERE ([A].[isVisible] = 1) AND [A].[ArtistId] = @ArtistId ORDER BY Id DESC OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY;">
                    <SelectParameters>
                        <asp:Parameter Name="Skip" Type="Int32" DefaultValue="0"/>
                        <asp:Parameter Name="Take" Type="Int32" DefaultValue="12"/>
                        <asp:Parameter Name="ArtistId" Type="String"/>
                        <asp:Parameter Name="CustomerId" Type="String"/>
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Script" runat="server">
</asp:Content>