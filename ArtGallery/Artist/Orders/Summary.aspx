<%@ Page Title="" Language="C#" MasterPageFile="~/Artist/Navbar.master" AutoEventWireup="true" CodeBehind="Summary.aspx.cs" Inherits="ArtGallery.Artist.Orders.Summary" %>
<asp:Content ID="Content1" ContentPlaceHolderID="VendorStyle" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="title" runat="server">Order Summary</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">Orders Summary for <%= ddlMonth.SelectedValue %> / <%= ddlYear.SelectedValue %></h1>
    <div class="row">
        <div style="width: 200px">
            <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control" OnInit="ddlMonth_Init"></asp:DropDownList>
        </div>
        <div style="width: 200px">
            <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control" OnInit="ddlYear_Init"></asp:DropDownList>
        </div>
        <asp:LinkButton ID="checkYear" runat="server" CssClass="btn btn-primary" OnClick="checkYear_Click"><i class="fa fa-search"></i></asp:LinkButton>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-center align-items-center">
                        <div id="chart"></div>
                    </div>
                </div>
                <div class="card-footer">
                    RM <%= Math.Round(totalAmount, 2) %>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="VendorScript" runat="server">
      <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script defer>
        const drawChart = () => {
            var data = google.visualization.arrayToDataTable([
                ['Day', 'Subtotal'],
                <% 
                    foreach(KeyValuePair<int, double> entry in collection){
                        Response.Write("['"+entry.Key+"', "+entry.Value+"],");
                    }
                %>
            ]);
            var view = new google.visualization.DataView(data);
            var options = {
                title: "Order Summary",
                width: 900,
                height: 500,
                legend: { position: "none" },
                vAxis: {
                    title: "Subtotal",
                    minValue: 0.0,
                },
                hAxis: {
                    title: "Day"
                }
            };
            var chart = new google.visualization.ColumnChart(document.getElementById("chart"));
            chart.draw(view, options);
        }
        google.charts.load("current", { packages: ['corechart'] });
        google.charts.setOnLoadCallback(drawChart);
    </script>
</asp:Content>
