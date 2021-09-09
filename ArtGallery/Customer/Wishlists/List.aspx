<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ArtGallery.Customer.Wishlists.List" %>
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
<asp:Content ID="title" ContentPlaceHolderID="title" runat="server">My Wishlist - Customer</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <% if (isAddedToCart) { %>
        <div class="alert alert-success">Item is added to your cart successfully!</div>
    <% } else if (isRemovedFromWishlist) { %>
        <div class="alert alert-success">Item is removed from your wishlist successfully!</div>
    <% } else if (unableToRemovedFromWishlist) { %>
        <div class="alert alert-warning">Unable to remove, the item is not in your wishlist!</div>
    <% }%>
    <h1 class="h3 mb-4 text-gray-800">My Wishlist</h1>
    <div class="container">
        <div class="row d-flex">
            <div class="col-12 text-center" runat="server" visible="false" id="NoRecords">
                <div class="row">
                    <div class="col-12"><h3>Oops... No Records Are Available</h3></div>
                    <div class="col-md-6 mx-auto"><img class="w-100" src="/public/img/searching.svg" alt="No Record Found Img" /></div>
                </div>
            </div>
            <asp:Repeater ID="Repeater1" runat="server" DataSourceID="PagingSource" OnItemCommand="Repeater1_ItemCommand" OnPreRender="Repeater1_PreRender" >
                <ItemTemplate>
                    <div class="col-xl-3 col-lg-4 col-md-6 p-2">
                        <div class="card">
                            <img class="card-img-top" src='<%# Convert.IsDBNull(Eval("Image")) ? "/public/img/image.svg" : "/Storage/Artworks/" + Eval("Image").ToString() %>'>
                            <div class="card-body">
                                <h5 class="card-title"><a href='/Artworks/Details.aspx?Id=<%# Eval("Id") %>'><%# Eval("Title") %></a></h5>
                                <p class="card-text text-overflow-hide"><%# Eval("Description") %></p>
                                <p class="card-text"><span class="text-success font-weight-bold">RM <%# ((Decimal)Eval("Price")).ToString("F") %></span></p>
                                <p class="card-text"><span class="badge badge-info"><%# Eval("StockQuantity") %> Stock Left</span></p>
                            </div>
                            <div class="card-footer">
                                <a href='/Customer/Artworks/Details.aspx?Id=<%# Eval("Id") %>' class="btn btn-primary" data-toggle="tooltip" title="More Details"><i class="fa fa-eye"></i></a>
                                <asp:LinkButton ID="btnRemoveWishlist" runat="server" CommandName="RemoveFromWishlist" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-danger" data-toggle="tooltip" title="Remove From Wishlist"><i class="far fa-fw fa-bookmark"></i></asp:LinkButton>
                                <asp:LinkButton ID="btnCart" runat="server" CommandName="AddToCart" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-success" data-toggle="tooltip" title="Add To Cart" ><i class="fa fa-fw fa-cart-plus"></i></asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="ArtworkSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM [Artworks] A RIGHT JOIN [Wishlists] W ON [A].[Id] = [W].[ArtworkId] WHERE ([A].[isVisible] = 1) AND CustomerId = @CustomerId;">
                <SelectParameters>
                    <asp:Parameter Name="CustomerId" Type="String"/>
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="PagingSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM [Artworks] A RIGHT JOIN [Wishlists] W ON [A].[Id] = [W].[ArtworkId] WHERE ([A].[isVisible] = 1) AND CustomerId = @CustomerId ORDER BY AddedAt DESC OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY;">
                <SelectParameters>
                    <asp:Parameter Name="Skip" Type="Int32" DefaultValue="0"/>
                    <asp:Parameter Name="Take" Type="Int32" DefaultValue="12"/>
                    <asp:Parameter Name="CustomerId" Type="String"/>
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>
    <div class="d-flex justify-content-center align-items-center">
        <UC:Pagination runat="server" ID="Pagination" StartingPage="0" />
    </div>
</asp:Content>