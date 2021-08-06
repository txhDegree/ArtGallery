<%@ Page Title="" Language="C#" MasterPageFile="~/Artist/Navbar.master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ArtGallery.Artist.Artworks.List" %>
<asp:Content ID="style" ContentPlaceHolderID="VendorStyle" runat="server">
    <style>
        .text-overflow-hide {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</asp:Content>
<asp:Content ID="title" ContentPlaceHolderID="title" runat="server">My Artworks - Artist</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">My Artworks</h1>
    <div class="row d-flex">

        
        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="ArtistArtworkSource">
            <ItemTemplate>
                <div class="col-md-3 p-2">
                    <div class="card">
                        <img class="card-img-top" src="/public/img/image.svg">
                        <div class="card-body">
                            <h5 class="card-title"><%# Eval("Title") %></h5>
                            <p class="card-text text-overflow-hide"><%# Eval("Description") %></p>
                            <p class="card-text"><span class="text-success font-weight-bold">RM <%# ((Decimal)Eval("Price")).ToString("F") %></span></p>
                            <p class="card-text"><span class="badge badge-info"><%# Eval("StockQuantity") %> Stock Left</span></p>
                            <a href="/Artist/Artworks/Edit.aspx?Id=<%# Eval("Id") %>" class="btn btn-primary">Edit</a>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        
        <asp:SqlDataSource ID="ArtistArtworkSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM [Artworks] WHERE ([ArtistId] = @ArtistId)">
            <SelectParameters>
                <asp:Parameter Name="ArtistId" Type="String"/>
            </SelectParameters>
        </asp:SqlDataSource>

    </div>
</asp:Content>