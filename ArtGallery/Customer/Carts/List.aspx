<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ArtGallery.Customer.Carts.List" %>
<%@ Register Src="~/Controls/Pagination.ascx" TagPrefix="UC" TagName="Pagination" %>
<asp:Content ID="style" ContentPlaceHolderID="VendorStyle" runat="server"></asp:Content>
<asp:Content ID="title" ContentPlaceHolderID="title" runat="server">My Cart - Customer</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">My Carts</h1>
    <% if (isDeleted) { %>
    <div class="alert alert-success">The artwork is deleted successfully.</div>
    <% } %>
    <div class="container">
        <div class="row d-flex">
            <div class="col-12 text-center" runat="server" visible="false" id="NoRecords">
                <div class="row">
                    <div class="col-12"><h3>Oops... No Records Are Available</h3></div>
                    <div class="col-md-6 mx-auto"><img class="w-100" src="/public/img/searching.svg" alt="No Record Found Img" /></div>
                </div>
            </div>
            <asp:Repeater ID="Repeater1" runat="server" DataSourceID="PagingSource" OnItemCommand="Repeater1_ItemCommand" OnPreRender="Repeater1_PreRender">
                <ItemTemplate>
                    <div class="col-xl-3 col-lg-4 col-md-6 p-2">
                        <div class="card">
                            <div class="card-img-top img-overflow" style="background-image: url(<%# Convert.IsDBNull(Eval("Image")) ? "/public/img/image.svg" : "/Storage/Artworks/" + Eval("Image").ToString() %>); height: 250px" ></div>
                            <div class="card-body">
                                <h5 class="card-title text-overflow-hide"><a href='/Artworks/Details.aspx?Id=<%# Eval("Id") %>'><%# Eval("Title") %></a></h5>
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
            <asp:SqlDataSource ID="PagingSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT *, [A].[Price] * [C].[Quantity] as Subtotal FROM [Artworks] A RIGHT JOIN [Carts] C ON [A].[Id] = [C].[ArtworkId], [aspnet_Users] U WHERE ([A].[isVisible] = 1) AND CustomerId = @CustomerId AND [A].[ArtistId] = [U].[UserId] ORDER BY AddedAt DESC OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY;">
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
                        <div class="col-12">
                            <div class="form-group">
                                <label>Address:</label> <span class="text-danger d-none" id="AddressError">Please select or create an address</span>
                                <asp:DropDownList CssClass="form-control" ID="AddressList" runat="server" DataSourceID="AddressSource" DataTextField="Label" DataValueField="Id" AppendDataBoundItems="true" >
                                    <asp:ListItem Value="">-- Select An Address --</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="AddressSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT [Id], [Label] FROM [Addresses] WHERE [CustomerId] = @CustomerId">
                                    <SelectParameters>
                                        <asp:Parameter Name="CustomerId" Type="String"/>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <button id="checkoutbtn" class="btn btn-primary btn-block">Checkout</button>
                </div>
            </div>
        </div>
    </div>
    <% } %>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="VendorScript">
    <script>
        const addresses = document.querySelector('select#Content_Content_AddressList')
        const addressError = document.querySelector('#AddressError');
        document.querySelector("#checkoutbtn").addEventListener('click', (e) => {
            e.preventDefault();
            addressError.classList.remove('d-inline-block');
            addressError.classList.add('d-none');
            if (addresses.value) {
                location = "/Customer/Orders/NewOrder.aspx?Id=" + addresses.value
            }
            else {
                addressError.classList.add('d-inline-block');
                addressError.classList.remove('d-none');
            }
        })
    </script>
</asp:Content>