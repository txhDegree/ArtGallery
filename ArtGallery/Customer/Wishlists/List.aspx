<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ArtGallery.Customer.Wishlists.List" %>
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
    <% if (isAddedToCart) { %>
        <div class="alert alert-success">Item is added to your cart successfully!</div>
    <% } else if (isRemovedFromWishlist) { %>
        <div class="alert alert-success">Item is removed from your wishlist successfully!</div>
    <% } else if (unableToRemovedFromWishlist) { %>
        <div class="alert alert-warning">Unable to remove, the item is not in your wishlist!</div>
    <% }%>
    <h1 class="h3 mb-4 text-gray-800">My Wishlist</h1>
    <div class="row d-flex">
        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="ArtworkSource" OnItemCommand="Repeater1_ItemCommand" >
            <ItemTemplate>
                <div class="col-md-3 p-2">
                    <div class="card">
                        <img class="card-img-top" src="/public/img/image.svg">
                        <div class="card-body">
                            <h5 class="card-title"><%# Eval("Title") %></h5>
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

    </div>
</asp:Content>