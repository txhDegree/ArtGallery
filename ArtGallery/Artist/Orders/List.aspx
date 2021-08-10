﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Artist/Navbar.master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ArtGallery.Artist.Orders.List" %>
<asp:Content ID="Content1" ContentPlaceHolderID="VendorStyle" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="title" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">My Orders</h1>
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
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
                            <asp:Repeater ID="Repeater1" runat="server" DataSourceID="ArtworkSource">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <a href='/Artist/Orders/Details.aspx?Id=<%# Eval("Id") %>'>#<%# Convert.ToInt32(Eval("Id")).ToString("00000.##") %></a>
                                        </td>
                                        <td><%# Eval("Status") %></td>
                                        <td><%# ((Decimal)Eval("TotalAmount")).ToString("F") %></td>
                                        <td><%# ((Decimal)Eval("ShippingFee")).ToString("F") %></td>
                                        <td><%# ((Decimal)Eval("AmountToPay")).ToString("F") %></td>
                                        <td><%# Convert.ToDateTime(Eval("Date")).ToString("ddd, dd/MM/yyyy hh:mm tt") %></td>
                                        <td><%# Convert.ToBoolean(Eval("isPaid")) ? Convert.ToDateTime(Eval("PaidAt")).ToString("ddd, dd/MM/yyyy hh:mm tt") : "-" %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:SqlDataSource ID="ArtworkSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM Orders WHERE ArtistId = @ArtistId">
                                <SelectParameters>
                                    <asp:Parameter Name="ArtistId" Type="String"/>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="VendorScript" runat="server">
</asp:Content>