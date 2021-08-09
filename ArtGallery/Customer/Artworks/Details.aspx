<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="ArtGallery.Customer.Artworks.Details" %>
<asp:Content ID="title" ContentPlaceHolderID="title" runat="server" >Artwork Details</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <div class="card m-2">
        <div class="card-body">
            <div class="row">
                <div class="col-md-6 d-flex justify-content-center align-items-center" style="">
                    <img runat="server" id="image" style="max-width: 100%; max-height: 100%" src="/public/img/image.svg" alt="Artwork Image" />
                </div>
                <div class="col-md-6">
                    <h1 class="mt-4" runat="server" id="lblTitle">Title</h1>
                    <h5 class="mt-2" runat="server" id="lblDesc" >Description here.</h5>
                    <div class="mt-2 alert alert-info">Price: <span class="font-weight-bold h5" runat="server" id="lblPrice">RM</span></div>
                    <div class="row px-3">
                        <div class="d-inline-block mr-3">Quantity: </div>
                        <div class="input-group mx-3" style="width: 150px">
                            <div class="input-group-prepend">
                                <button class="btn btn-outline-secondary" type="button" data-minus="">-</button>
                            </div>
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtQty" TextMode="Number" min="1" max="999" Text="1"></asp:TextBox>
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary" type="button" data-plus="">+</button>
                            </div>
                        </div>
                        <div class="ml-3"><span class="badge badge-info" runat="server" id="lblStockQty">0</span> in stock</div>
                    </div>
                    <asp:RangeValidator CssClass="text-danger" ID="rangeValidator" ControlToValidate="txtQty" MinimumValue="1" Type="Integer" EnableClientScript="false" runat="server" />
                    <div class="mt-3">
                        <span class="badge badge-info" data-toggle="tooltip" title="Artist"><i class="fa fa-fw fa-user"></i> <asp:Label runat="server" ID="lblArtistName" Text="ArtistName"></asp:Label></span>
                        <span class="badge badge-warning" data-toggle="tooltip" title="Year Created"><i class="fa fa-fw fa-calendar-alt"></i> <asp:Label runat="server" ID="lblYear" Text="1900"></asp:Label></span>
                    </div>
                    <div class="mt-1">
                        <!--- <asp:LinkButton runat="server" ID="btnBuyNow" CssClass="btn btn-info">Buy Now</asp:LinkButton> -->
                        <asp:LinkButton runat="server" ID="btnAddToCart" CssClass="btn btn-success" OnClick="btnAddToCart_Click"><i class="fa fa-fw fa-cart-plus"></i> Add To Cart</asp:LinkButton>
                    </div>
                    <% if (isAddedToCart) { %>
                        <div class="mt-2 alert alert-success">Item is added to your cart successfully!</div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="script" ContentPlaceHolderID="VendorScript" runat="server">
    <script defer="defer">
        const qty = document.querySelector("#Content_Content_txtQty")
        document.querySelector("[data-minus]").addEventListener('click', (e) => {
            qty.value = Math.max(parseInt(qty.value)-1, 1)
        })
        document.querySelector("[data-plus]").addEventListener('click', (e) => {
            qty.value = Math.min(parseInt(qty.value)+1, parseInt(qty.getAttribute("max")))
        })
    </script>
</asp:Content>