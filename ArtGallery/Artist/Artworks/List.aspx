<%@ Page Title="" Language="C#" MasterPageFile="~/Artist/Navbar.master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ArtGallery.Artist.Artworks.List" %>
<%@ Register Src="~/Controls/Pagination.ascx" TagPrefix="UC" TagName="Pagination" %>
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
    <div class="container">
        <div class="row d-flex">
            <div class="col-12 text-center" runat="server" visible="false" id="NoRecords">
                <div class="row">
                    <div class="col-12"><h3>Oops... No Records Are Available</h3></div>
                    <div class="col-md-6 mx-auto"><img class="w-100" src="/public/img/searching.svg" alt="No Record Found Img" /></div>
                </div>
            </div>
            <asp:Repeater ID="Repeater1" runat="server" DataSourceID="PagingSource" Visible="true" OnPreRender="Repeater1_PreRender">
                <ItemTemplate>
                    <div class="col-xl-3 col-lg-4 col-md-6 p-2">
                        <div class="card">
                            <img class="card-img-top" src='<%# Convert.IsDBNull(Eval("Image")) ? "/public/img/image.svg" : "/Storage/Artworks/" + Eval("Image").ToString() %>' >
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
            <asp:SqlDataSource ID="ArtistArtworkSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM [Artworks] WHERE ([ArtistId] = @ArtistId) ORDER BY Id DESC">
                <SelectParameters>
                    <asp:Parameter Name="ArtistId" Type="String"/>
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="PagingSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM [Artworks] WHERE ([ArtistId] = @ArtistId) ORDER BY Id DESC OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY">
                <SelectParameters>
                    <asp:Parameter Name="Skip" Type="Int32" DefaultValue="0"/>
                    <asp:Parameter Name="Take" Type="Int32" DefaultValue="12"/>
                    <asp:Parameter Name="ArtistId" Type="String"/>
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
        <div class="d-flex justify-content-center align-items-center">
            <UC:Pagination runat="server" ID="Pagination" StartingPage="0" />
        </div>
    </div>
</asp:Content>