<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ArtGallery.Customer.Orders.List" %>
<%@ Register Src="~/Controls/Pagination.ascx" TagPrefix="UC" TagName="Pagination" %>
<asp:Content ID="Content1" ContentPlaceHolderID="VendorStyle" runat="server">
    <style>
        .badge-pending{
            color: #fff;
            background-color: #e74a3b;
        }
        .badge-paid{
            color: #fff;
            background-color: #36b9cc;
        }
        .badge-preparing {
            color: #fff;
            background-color: #4e73df;
        }
        .badge-shipping{
            color: #fff;
            background-color: #f6c23e;
        }
        .badge-complete{
            color: #fff;
            background-color: #1cc88a;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="title" runat="server">My Orders - Customer</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">My Orders</h1>
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <asp:DropDownList ID="OrderStatusList" runat="server" CssClass="form-control" AutoPostBack="true">
                                <asp:ListItem Value=" ">-- Select Order Status --</asp:ListItem>
                                <asp:ListItem>pending</asp:ListItem>
                                <asp:ListItem>paid</asp:ListItem>
                                <asp:ListItem>preparing</asp:ListItem>
                                <asp:ListItem>shipping</asp:ListItem>
                                <asp:ListItem>complete</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order Id</th>
                                <th>Status</th>
                                <th>Total Amount</th>
                                <th>Shipping Fee</th>
                                <th>Amount To Pay</th>
                                <th>Order At</th>
                                <th>Paid At</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr runat="server" visible="false" id="NoRecords">
                                <td colspan="7">
                                    <div class="col-12 text-center">
                                        <div class="row">
                                            <div class="col-12"><h3>Oops... No Records Are Available</h3></div>
                                            <div class="col-md-6 mx-auto"><img class="w-100" src="/public/img/searching.svg" alt="No Record Found Img" /></div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <asp:Repeater ID="Repeater1" runat="server" DataSourceID="PagingSource">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <a href='/Customer/Orders/Details.aspx?Id=<%# Eval("Id") %>'>#<%# Convert.ToInt32(Eval("Id")).ToString("00000.##") %></a></td>
                                        <td><span class='badge badge-<%# Eval("Status").ToString().Trim() %>'><%# Eval("Status").ToString().Trim() %></span></td>
                                        <td>RM <%# ((Decimal)Eval("TotalAmount")).ToString("F") %></td>
                                        <td>RM <%# ((Decimal)Eval("ShippingFee")).ToString("F") %></td>
                                        <td>RM <%# ((Decimal)Eval("AmountToPay")).ToString("F") %></td>
                                        <td><%# Convert.ToDateTime(Eval("Date")).ToString("dd/MM/yyyy hh:mm tt") %></td>
                                        <td><%# Convert.ToBoolean(Eval("isPaid")) ? Convert.ToDateTime(Eval("PaidAt")).ToString("dd/MM/yyyy hh:mm tt") : "-" %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:SqlDataSource ID="ArtworkSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM [Orders] WHERE (([CustomerId] = @CustomerId) AND ([Status] LIKE '%' + @Status + '%')) ORDER BY Date DESC">
                                <SelectParameters>
                                    <asp:Parameter Name="CustomerId" Type="String"/>
                                    <asp:ControlParameter ControlID="OrderStatusList" Name="Status" PropertyName="SelectedValue" Type="String" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="PagingSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM [Orders] WHERE (([CustomerId] = @CustomerId) AND ([Status] LIKE '%' + @Status + '%')) ORDER BY Date DESC OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY">
                                <SelectParameters>
                                    <asp:Parameter Name="Skip" Type="Int32" DefaultValue="0"/>
                                    <asp:Parameter Name="Take" Type="Int32" DefaultValue="12"/>
                                    <asp:Parameter Name="CustomerId" Type="String"/>
                                    <asp:ControlParameter ControlID="OrderStatusList" Name="Status" PropertyName="SelectedValue" Type="String" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="d-flex justify-content-center align-items-center">
        <UC:Pagination runat="server" ID="Pagination" StartingPage="0" />
    </div>
    <% if(paymentRequired) { %>
    <div class="row mt-3">
        <div class="col-12">
            <a href="/Customer/Payments/MakePayment.aspx" class="btn btn-success btn-block"><i class="fa fa-fw fa-money-bill-wave"></i> Make Payment Now</a>
        </div>
    </div>
    <% } %>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="VendorScript" runat="server">
</asp:Content>
