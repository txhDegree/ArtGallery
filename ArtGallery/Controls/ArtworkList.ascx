<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArtworkList.ascx.cs" Inherits="ArtGallery.Controls.ArtworkList" %>
<%@ Register Src="~/Controls/Pagination.ascx" TagPrefix="UC" TagName="Pagination" %>
<% if (isAddedToCart) { %>
    <div class="alert alert-success">Item is added to your cart successfully!</div>
<% } else if (isAddedToWishlist) { %>
    <div class="alert alert-success">Item is added to your wishlist successfully!</div>
<% } else if (isInWishlist) { %>
    <div class="alert alert-warning">The item is already in your wishlist!</div>
<% } else if (isRemovedFromWishlist) { %>
    <div class="alert alert-success">Item is removed from your wishlist successfully!</div>
<% } else if (unableToRemovedFromWishlist) { %>
    <div class="alert alert-warning">Unable to remove, the item is not in your wishlist!</div>
<% }%>
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
                    <div class="card-img-top img-overflow" style="background-image: url(<%# Convert.IsDBNull(Eval("Image")) ? "/public/img/image.svg" : "/Storage/Artworks/" + Eval("Image").ToString() %>); height: 250px" ></div>
                    <div class="card-body">
                        <h5 class="card-title text-overflow-hide"><a href='/Artworks/Details.aspx?Id=<%# Eval("Id") %>'><%# Eval("Title") %></a></h5>
                        <p class="card-text text-overflow-hide"><%# Eval("Description") %></p>
                        <p class="card-text"><span class="text-success font-weight-bold">RM <%# ((Decimal)Eval("Price")).ToString("F") %></span></p>
                        <p class="card-text"><span class="badge badge-info"><%# Eval("StockQuantity") %> Stock Left</span></p>
                        <p class="card-text"><a class="badge badge-warning" href="/Artworks/Artist.aspx?Artist=<%# Eval("ArtistName") %>"><%# Eval("ArtistName") %></a></p>
                    </div>
                    <div class="card-footer">
                        <a href='/Artworks/Details.aspx?Id=<%# Eval("Id") %>' class="btn btn-primary" data-toggle="tooltip" title="More Details"><i class="fa fa-eye"></i></a>
                        <asp:LinkButton Visible='<%# Eval("IsAdded").ToString() == "1" %>' ID="btnRemoveWishlist" runat="server" CommandName="RemoveFromWishlist" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-danger" data-toggle="tooltip" title="Remove From Wishlist"><i class="far fa-fw fa-bookmark"></i></asp:LinkButton>
                        <asp:LinkButton Visible='<%# Eval("IsAdded").ToString() == "0" %>' ID="btnWishlist" runat="server" CommandName="AddToWishlist" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-warning" data-toggle="tooltip" title="Add To Wishlist"><i class="far fa-fw fa-bookmark"></i></asp:LinkButton>
                        <asp:LinkButton ID="btnCart" runat="server" CommandName="AddToCart" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-success" data-toggle="tooltip" title="Add To Cart" ><i class="fa fa-fw fa-cart-plus"></i></asp:LinkButton>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</div>
<div class="d-flex justify-content-center align-items-center">
    <UC:Pagination runat="server" ID="Pagination" StartingPage="0" />
</div>