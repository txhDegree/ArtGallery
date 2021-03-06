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
                <div class="row">
                    <div class="col-12">
                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="alert alert-danger" />
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Search:</label>
                            <asp:TextBox runat="server" ID="search" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Price From:<asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="" CssClass="text-danger" Text="*" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator></label>
                            <asp:TextBox runat="server" ID="price_from" TextMode="Number" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Price To:<asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="" CssClass="text-danger" Text="*" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator></label>
                            <asp:TextBox runat="server" ID="price_to" TextMode="Number" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <asp:LinkButton runat="server" ID="searchSubmi" CssClass="btn btn-primary"><i class="fa fa-search"></i></asp:LinkButton>
                    </div>
                </div>
                <UC:Artworks runat="server" ID="ArtworkList"/>
                <asp:SqlDataSource ID="ArtworkSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT *, U.UserName as ArtistName, CASE WHEN [W].[CustomerId] IS NULL THEN 0 ELSE 1 END AS IsAdded FROM [Artworks] A LEFT JOIN aspnet_Users U ON A.ArtistId = U.UserId LEFT JOIN (SELECT * FROM [Wishlists] WHERE [CustomerId] = @CustomerId) W ON [A].[Id] = [W].[ArtworkId] WHERE ([A].[isVisible] = 1) AND [A].[ArtistId] = @ArtistId AND (LOWER([A].[Title]) LIKE LOWER('%' + @Search + '%') OR LOWER([A].[Description]) LIKE LOWER('%' + @Search + '%') OR @Search IS NULL) AND ([A].[Price] >= @From OR @From IS NULL) AND ([A].[Price] <= @To OR @To IS NULL) ORDER BY Id DESC;" CancelSelectOnNullParameter="false">
                    <SelectParameters>
                        <asp:Parameter Name="ArtistId" Type="String"/>
                        <asp:Parameter Name="CustomerId" Type="String"/>
                        <asp:ControlParameter Name="Search" Type="String" ControlID="search" PropertyName="Text" />
                        <asp:ControlParameter Name="From" Type="Double" ControlID="price_from" PropertyName="Text"  />
                        <asp:ControlParameter Name="To" Type="Double" ControlID="price_to" PropertyName="Text"  />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="PagingSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT *, U.UserName as ArtistName, CASE WHEN [W].[CustomerId] IS NULL THEN 0 ELSE 1 END AS IsAdded FROM [Artworks] A LEFT JOIN aspnet_Users U ON A.ArtistId = U.UserId LEFT JOIN (SELECT * FROM [Wishlists] WHERE [CustomerId] = @CustomerId) W ON [A].[Id] = [W].[ArtworkId] WHERE ([A].[isVisible] = 1) AND [A].[ArtistId] = @ArtistId AND (LOWER([A].[Title]) LIKE LOWER('%' + @Search + '%') OR LOWER([A].[Description]) LIKE LOWER('%' + @Search + '%') OR @Search IS NULL) AND ([A].[Price] >= @From OR @From IS NULL) AND ([A].[Price] <= @To OR @To IS NULL) ORDER BY Id DESC OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY;" CancelSelectOnNullParameter="false">
                    <SelectParameters>
                        <asp:ControlParameter Name="Search" Type="String" ControlID="search" PropertyName="Text"  />
                        <asp:ControlParameter Name="From" Type="Double" ControlID="price_from" PropertyName="Text"  />
                        <asp:ControlParameter Name="To" Type="Double" ControlID="price_to" PropertyName="Text"  />
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