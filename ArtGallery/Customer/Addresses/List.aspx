<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="ArtGallery.Customer.Addresses.List" %>
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
<asp:Content ID="title" ContentPlaceHolderID="title" runat="server">Art Galleries - Customer</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">My Addresses</h1>
    <div class="row d-flex">
        <% if (isDeleted) { %>
        <div class="col-12">
            <div class="alert alert-success">Your address is deleted successfully.</div>
        </div>
        <% } %>
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
                        <div class="card-body">
                            <h5 class="card-title"><a href='/Customer/Addresses/Edit.aspx?Id=<%# Eval("Id") %>'><%# Eval("Label") %></a></h5>
                            <p class="card-text text-overflow-hide"><%# Eval("Address") %></p>
                            <p class="card-text"><span class="badge badge-info"><%# Eval("PostalCode") %></span> <span class="badge badge-info"><%# Eval("CityName") %></span> <span class="badge badge-info"><%# Eval("StateName") %></span></p>
                            <div class="btn-group">
                                <a href='/Customer/Addresses/Edit.aspx?Id=<%# Eval("Id") %>' class="btn btn-sm btn-primary" data-toggle="tooltip" title="Edit"><i class="fa fa-fw fa-edit"></i></a>
                                <asp:LinkButton runat="server" CommandName="RemoveAddress" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-danger" data-toggle="tooltip" title="Delete Address"><i class="fa fa-fw fa-trash"></i></asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="ArtworkSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM Addresses A LEFT JOIN States S ON A.State = S.StateId LEFT JOIN Cities C ON C.CityId = A.City WHERE A.CustomerId = @CustomerId  ORDER BY Id ASC;">
            <SelectParameters>
                <asp:Parameter Name="CustomerId" Type="String"/>
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="PagingSource" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM Addresses A LEFT JOIN States S ON A.State = S.StateId LEFT JOIN Cities C ON C.CityId = A.City WHERE (A.CustomerId = @CustomerId) ORDER BY Id ASC OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY;">
            <SelectParameters>
                <asp:Parameter Name="Skip" Type="Int32" DefaultValue="0"/>
                <asp:Parameter Name="Take" Type="Int32" DefaultValue="12"/>
                <asp:Parameter Name="CustomerId" Type="String"/>
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <div class="d-flex justify-content-center align-items-center">
        <UC:Pagination runat="server" ID="Pagination" StartingPage="0" />
    </div>
</asp:Content>