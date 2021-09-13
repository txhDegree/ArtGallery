<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Navbar.master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="ArtGallery.Customer.Addresses.Edit" %>
<asp:Content ID="title" ContentPlaceHolderID="title" runat="server">Create New Address - Customer</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">Create New Address</h1>
    <div class="row">
        <div class="col-sm-6 mx-auto">
            <div class="card">
                <div class="card-body">
                    <% if (isUpdated) { %>
                    <div class="alert alert-success">
                        New address is created successfully!
                    </div>
                    <% } %>
                    <div class="form-row">
                        <div class="form-group col-12">
                            <label>Address Title
                                <asp:RequiredFieldValidator ID="RequiredTitleValidator" runat="server" ErrorMessage="Address Title is required" Text="*" CssClass="text-danger" ControlToValidate="txtTitle"></asp:RequiredFieldValidator>
                            </label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="e.g. Home, Office..." ID="txtTitle" MaxLength="50"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Receiver Name
                                <asp:RequiredFieldValidator ID="RequiredNameValidator" runat="server" ErrorMessage="Receiver Name is required" Text="*" CssClass="text-danger" ControlToValidate="txtName"></asp:RequiredFieldValidator>
                            </label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="Receiver Name" ID="txtName" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-6">
                            <label>Receiver Contact
                                <asp:RequiredFieldValidator ID="RequiredContactValidator" runat="server" ErrorMessage="Receiver Contact is required" Text="*" CssClass="text-danger" ControlToValidate="txtContact"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidatorContact" runat="server" ErrorMessage="Invalid Contact Number" Text="*" CssClass="text-danger" ControlToValidate="txtContact" ValidationExpression="\d{8,9}"  ></asp:RegularExpressionValidator>
                            </label>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">+60</span>
                                </div>
                                <asp:TextBox runat="server" CssClass="form-control" placeholder="234567890" ID="txtContact" MaxLength="9"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-12">
                            <label>Address
                                <asp:RequiredFieldValidator ID="RequiredAddressValidator" runat="server" ErrorMessage="Address is required" Text="*" CssClass="text-danger" ControlToValidate="txtAddress"></asp:RequiredFieldValidator>
                            </label>
                            <asp:TextBox runat="server" CssClass="form-control" TextMode="Multiline" ID="txtAddress" MaxLength="64"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>State</label>
                            <asp:DropDownList CssClass="form-control" ID="ddlState" runat="server" DataSourceID="SqlDataSource1" DataTextField="StateName" DataValueField="StateId" AutoPostBack="true">
                                <asp:ListItem>-- Select State --</asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM [States] ORDER BY StateName"></asp:SqlDataSource>
                        </div>
                        <div class="form-group col-md-6">
                            <label>City</label>
                            <input type="hidden" id="hiddenCity" runat="server" value="" />
                            <asp:DropDownList CssClass="form-control" ID="ddlCity" runat="server" DataSourceID="SqlDataSource2" DataTextField="CityName" DataValueField="CityId" AutoPostBack="true">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT [CityId], [CityName] FROM [Cities] WHERE ([StateId] = @StateId) ORDER BY CityName">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlState" Name="StateId" PropertyName="SelectedValue" Type="String" DefaultValue="0" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-12">
                            <label>Postal Code</label>
                            <input type="hidden" id="hiddenPostCode" runat="server" value="" />
                            <asp:DropDownList CssClass="form-control" ID="ddlPostalCode" runat="server" DataSourceID="SqlDataSource3" DataTextField="PostalCode" DataValueField="PostalCode">
                                <asp:ListItem>-- Select Postal Code --</asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT * FROM [PostalCodes] WHERE ([CityId] = @CityId) ORDER BY PostalCode">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlCity" Name="CityId" PropertyName="SelectedValue" Type="Int32" DefaultValue="0" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                    </div>
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="alert alert-danger" />
                </div>
                <div class="card-footer">
                    <asp:LinkButton runat="server" ID="saveBtn" CssClass="btn btn-primary" OnClick="saveBtn_Click"><i class="fa fa-fw fa-save"></i> Save</asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
    <% if(!IsPostBack){ %>
    <script>
        document.querySelector('#Content_Content_ddlCity').querySelector(`[value="${document.querySelector('#Content_Content_hiddenCity').value}"]`).selected = "selected";
        document.querySelector('#Content_Content_ddlPostalCode').querySelector(`[value="${document.querySelector('#Content_Content_hiddenPostCode').value}"]`).selected = "selected";
    </script>
    <%} %>
</asp:Content>