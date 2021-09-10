<%@ Page Title="" Language="C#" MasterPageFile="~/Artworks/Navbar.master" AutoEventWireup="true" CodeBehind="Artist.aspx.cs" Inherits="ArtGallery.Artworks.Artist" %>
<%@ Register Src="~/Controls/Pagination.ascx" TagPrefix="UC" TagName="Pagination" %>
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
                <p class="card-text" runat="server" id="abtMe">Loasdjfh aqlwuerh lqu roq qulweyhrjdhf qiry qh fsdja </p>
            </div>
        </div>
        <div class="card mt-3">
            <div class="card-body">
                <h5 class="card-title">My Artworks</h5>
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
                <div class="row">
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
                                        <a href='/Artworks/Details.aspx?Id=<%# Eval("Id") %>' class="btn btn-primary" data-toggle="tooltip" title="More Details"><i class="fa fa-eye"></i></a>
                                        <asp:LinkButton Visible='<%# Eval("IsAdded").ToString() == "1" %>' ID="btnRemoveWishlist" runat="server" CommandName="RemoveFromWishlist" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-danger" data-toggle="tooltip" title="Remove From Wishlist"><i class="far fa-fw fa-bookmark"></i></asp:LinkButton>
                                        <asp:LinkButton Visible='<%# Eval("IsAdded").ToString() == "0" %>' ID="btnWishlist" runat="server" CommandName="AddToWishlist" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-warning" data-toggle="tooltip" title="Add To Wishlist"><i class="far fa-fw fa-bookmark"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnCart" runat="server" CommandName="AddToCart" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-success" data-toggle="tooltip" title="Add To Cart" ><i class="fa fa-fw fa-cart-plus"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:SqlDataSource ID="ArtworkSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT *, CASE WHEN [W].[CustomerId] IS NULL THEN 0 ELSE 1 END AS IsAdded FROM [Artworks] A LEFT JOIN (SELECT * FROM [Wishlists] WHERE [CustomerId] = @CustomerId) W ON [A].[Id] = [W].[ArtworkId] WHERE ([A].[isVisible] = 1) AND [A].[ArtistId] = @ArtistId  ORDER BY Id DESC;">
                        <SelectParameters>
                            <asp:Parameter Name="ArtistId" Type="String"/>
                            <asp:Parameter Name="CustomerId" Type="String"/>
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="PagingSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT *, CASE WHEN [W].[CustomerId] IS NULL THEN 0 ELSE 1 END AS IsAdded FROM [Artworks] A LEFT JOIN (SELECT * FROM [Wishlists] WHERE [CustomerId] = @CustomerId) W ON [A].[Id] = [W].[ArtworkId] WHERE ([A].[isVisible] = 1) AND [A].[ArtistId] = @ArtistId ORDER BY Id DESC OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY;">
                        <SelectParameters>
                            <asp:Parameter Name="Skip" Type="Int32" DefaultValue="0"/>
                            <asp:Parameter Name="Take" Type="Int32" DefaultValue="12"/>
                            <asp:Parameter Name="ArtistId" Type="String"/>
                            <asp:Parameter Name="CustomerId" Type="String"/>
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
                <div class="d-flex justify-content-center align-items-center">
                    <UC:Pagination runat="server" ID="Pagination" StartingPage="0" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Script" runat="server">
</asp:Content>