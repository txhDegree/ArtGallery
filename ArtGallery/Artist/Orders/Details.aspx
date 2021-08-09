<%@ Page Title="" Language="C#" MasterPageFile="~/Artist/Navbar.master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="ArtGallery.Artist.Orders.Details" %>
<asp:Content ID="Content1" ContentPlaceHolderID="VendorStyle" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="title" runat="server">Order Details</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">Order Details <span runat="server" id="lblOrderId" class="badge badge-info"></span></h1>
    <% if (isUpdated) { %>
    <div class="alert alert-success">The Order Details Is Updated Successfully.</div>
    <% } %>
    <div class="row">
        <div class="col-md-8 mx-auto">
            <div class="card">
                <div class="card-body">
                    <div class="card-title">Order Details</div>
                    <div class="row">
                        <div class="col-12 d-lg-block d-none mb-2">
                            <div class="progress">
                                <div runat="server" id="progressOrderAt" visible="true" class="progress-bar bg-success" role="progressbar" style="width: 20%" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">Place Order</div>
                                <div runat="server" id="progressPaidAt" visible="true" class="progress-bar bg-success" role="progressbar" style="width: 20%" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">Payment</div>
                                <div runat="server" id="progressPreparingAt" visible="true" class="progress-bar bg-success" role="progressbar" style="width: 20%" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">Preparing</div>
                                <div runat="server" id="progressShippingAt" visible="true" class="progress-bar bg-success" role="progressbar" style="width: 20%" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">Shipping</div>
                                <div runat="server" id="progressCompleteAt" visible="true" class="progress-bar bg-success" role="progressbar" style="width: 20%" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">Complete</div>
                            </div>
                            <div class="row text-center ">
                                <small style="flex: 0 0 20%" runat="server" id="smallOrderAt">-</small>
                                <small style="flex: 0 0 20%" runat="server" id="smallPaidAt">-</small>
                                <small style="flex: 0 0 20%" runat="server" id="smallPreparingAt">-</small>
                                <small style="flex: 0 0 20%" runat="server" id="smallShippingAt">-</small>
                                <small style="flex: 0 0 20%" runat="server" id="smallCompleteAt">-</small>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>Order At</label>
                            <p runat="server" id="lblOrderAt">-</p>
                        </div>
                        <div class="col-md-6">
                            <label>Customer</label>
                            <p runat="server" id="lblCustomerName">-</p>
                        </div>
                        <div class="col-md-6">
                            <label>Amount To Pay</label>
                            <p runat="server" id="lblAmountToPay">-</p>
                        </div>
                        <div class="col-md-6">
                            <label>Tracking No.</label>
                            <p><span runat="server" id="lblTrackingNo" onclick="linkTrack(this.innerText)" class="btn btn-info">-</span></p>
                        </div>
                        <div class="col-md-6 d-lg-none">
                            <label>Paid At</label>
                            <p runat="server" id="lblPaidAt">-</p>
                        </div>
                        <div class="col-md-6 d-lg-none">
                            <label>Preparing At</label>
                            <p runat="server" id="lblPreparingAt">-</p>
                        </div>
                        <div class="col-md-6 d-lg-none">
                            <label>Shipping At</label>
                            <p runat="server" id="lblShippingAt">-</p>
                        </div>
                        <div class="col-md-6 d-lg-none">
                            <label>Complete At</label>
                            <p runat="server" id="lblCompleteAt">-</p>
                        </div>
                    </div>
                    <hr />
                    <div class="card-title">Shipment Details</div>
                    <div class="row">
                         <div class="col-md-6">
                            <label>Receiver Name</label>
                            <p runat="server" id="lblReceiverName">-</p>
                        </div>
                        <div class="col-md-6">
                            <label>Receiver Contact</label>
                            <p runat="server" id="lblReceiverContact">-</p>
                        </div>
                        <div class="col-12">
                            <label>Address</label>
                            <p runat="server" id="lblShippingAddress">-</p>
                        </div>
                    </div>
                    <hr />
                    <div class="card-title">Artwork Details</div>
                    <div class="row">
                        <div class="col-12">
                            <table class="table table-bordered table-hover table-light table-striped">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Unit Price</th>
                                        <th>Quantity</th>
                                        <th>Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="OrderDetailsRepeater" runat="server" DataSourceID="OrderDetailsSource">
                                        <ItemTemplate>
                                            <tr>
                                                <td><a href='/Customer/Artworks/Details.aspx?Id=<%# Eval("ArtworkId") %>'><%# Eval("ArtworkTitle") %></a></td>
                                                <td><p class="mb-0"><span class="d-inline-block w-25">RM</span><span class="d-inline-block w-75 text-right"><%# Convert.ToDecimal(Eval("UnitPrice")).ToString("F") %></span></p></td>
                                                <td><%# Eval("Quantity") %></td>
                                                <td><p class="mb-0"><span class="d-inline-block w-25">RM </span><span class="d-inline-block w-75 text-right"><%# (Convert.ToDouble(Eval("UnitPrice"))*Convert.ToInt32(Eval("Quantity"))).ToString("F") %></span></p></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <asp:SqlDataSource ID="OrderDetailsSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM OrderDetail WHERE OrderId = @OrderId">
                                        <SelectParameters>
                                            <asp:Parameter Name="OrderId" Type="String"/>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <% switch (status) {
                        case "pending": %>
                            <div class="alert alert-warning">Waiting for customer payment, you can prepare this order once the payment is made by them.</div>
                    <%  break;
                        case "paid": %>
                            <asp:LinkButton runat="server" ID="btnPrepare" CssClass="btn btn-primary" OnClick="btnPrepare_Click">Update to Preparing</asp:LinkButton>
                    <%  break;
                        case "preparing": %>
                        <div class="input-group">
                            <asp:TextBox ID="txtTrackingNo" runat="server" placeholder="Tracking Number" CssClass="form-control"></asp:TextBox>
                            <div class="input-group-append">
                                <asp:LinkButton runat="server" ID="btnShipping" CssClass="btn btn-primary" OnClick="btnShipping_Click">Update to Shipping</asp:LinkButton>
                            </div>
                        </div>
                    <%  break;
                        case "shipping": %>
                        <div class="alert alert-warning">This order is still in shipping process. The amount will be transfer to your wallet once the order is marked complete by customer.</div>
                    <%  break;
                        case "complete": %>
                        <div class="alert alert-success">This order is completed. The amount has been transfered into your wallet.</div>
                    <%  break; } %>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="VendorScript" runat="server">
    <script src="//www.tracking.my/track-button.js" defer="defer"></script>
    <script defer="defer">
      function linkTrack(num) {
        TrackButton.track({
          tracking_no: num
        });
      }
    </script>
</asp:Content>
