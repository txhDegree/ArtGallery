<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ArtGallery.Customer.Carts.List" %>
<asp:Content ID="style" ContentPlaceHolderID="VendorStyle" runat="server">
    <style>
        .text-overflow-hide {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</asp:Content>
<asp:Content ID="title" ContentPlaceHolderID="title" runat="server">My Cart - Customer</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">My Carts</h1>
    <div class="row d-flex">
        <div class="col-12 text-center" runat="server" visible="false" id="NoRecords">
            <div class="row">
                <div class="col-12"><h3>Oops... No Records Are Available</h3></div>
                <div class="col-md-6 mx-auto"><img class="w-100" src="/public/img/searching.svg" alt="No Record Found Img" /></div>
            </div>
        </div>
        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="ArtworkSource" OnItemCommand="Repeater1_ItemCommand" OnPreRender="Repeater1_PreRender">
            <ItemTemplate>
                <div class="col-xl-3 col-lg-4 col-md-6 p-2">
                    <div class="card">
                        <img class="card-img-top" src="/public/img/image.svg">
                        <div class="card-body">
                            <h5 class="card-title"><a href='/Customer/Artworks/Details.aspx?Id=<%# Eval("Id") %>'><%# Eval("Title") %></a></h5>
                            <p class="card-text"><span class="badge badge-primary"><%# Eval("UserName") %></span> <span class="badge badge-info"><%# Eval("StockQuantity") %> Stock Left</span></p>
                            <p class="card-text">RM <%# ((Decimal)Eval("Price")).ToString("F") %> × <%# Eval("Quantity") %></p>
                            <p class="card-text">Subtotal: <span class="text-success font-weight-bold">RM <%# ((Decimal)Eval("Subtotal")).ToString("F") %></span></p>
                        </div>
                        <div class="card-footer">
                            <asp:LinkButton runat="server" CommandName="RemoveFromCart" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-danger" data-toggle="tooltip" title="Remove From Cart"><i class="fa fa-fw fa-trash-alt"></i></asp:LinkButton>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="ArtworkSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT *, [A].[Price] * [C].[Quantity] as Subtotal FROM [Artworks] A RIGHT JOIN [Carts] C ON [A].[Id] = [C].[ArtworkId], [aspnet_Users] U WHERE ([A].[isVisible] = 1) AND CustomerId = @CustomerId AND [A].[ArtistId] = [U].[UserId] ORDER BY AddedAt DESC;">
            <SelectParameters>
                <asp:Parameter Name="CustomerId" Type="String"/>
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <% if(checkoutAvailable) { %>
    <div class="row mt-3">
        <div class="col-md-6 mx-auto">
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-12">
                            <table class="table">
                                <tr>
                                    <th>Total Artwork Purchased</th>
                                    <td><span runat="server" id="lblTotalCount" class="text-success"></span></td>
                                </tr>
                                <tr>
                                    <th>Total Amount</th>
                                    <td><span runat="server" id="lblTotalAmount" class="text-success"></span></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <asp:LinkButton runat="server" ID="btnCreateOrder" PostBackUrl="/Customer/Orders/NewOrder.aspx" CssClass="btn btn-primary btn-block">Checkout</asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
    <% } %>
</asp:Content>
<asp:Content ContentPlaceHolderID="VendorScript" runat="server">
</asp:Content>