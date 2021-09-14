<%@ Page Title="" Language="C#" MasterPageFile="~/Artist/Navbar.master" AutoEventWireup="true" CodeBehind="Create.aspx.cs" Inherits="ArtGallery.Artist.Artworks.Create" %>
<asp:Content ID="title" ContentPlaceHolderID="title" runat="server">Create New Artwork - Artist</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">Create New Artwork</h1>
    <div class="row">
        <div class="col-sm-6 mx-auto">
            <div class="card">
                <div class="card-body">
                    <% if (isCreated) { %>
                    <div class="alert alert-success">
                        New artwork is created successfully!
                    </div>
                    <% } %>
                    <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage=""></asp:CustomValidator>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Artwork Title
                                <asp:RequiredFieldValidator ID="RequiredTitleValidator" ControlToValidate="txtTitle" runat="server" ErrorMessage="Artwork Title is required" Text="*" CssClass="text-danger"></asp:RequiredFieldValidator>
                            </label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="Artwork Title" ID="txtTitle" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-6">
                            <label>Year Created
                                <asp:RequiredFieldValidator ID="RequiredYearValidator" ControlToValidate="txtYear" runat="server" ErrorMessage="Year Created is required" Text="*" CssClass="text-danger"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="RangeValidatorYear" Type="Integer" ControlToValidate="txtYear" runat="server" ErrorMessage="This is not a valid year" Text="*" CssClass="text-danger" MinimumValue="1000"></asp:RangeValidator>
                            </label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="Year Created" MaxLength="4" ID="txtYear" ></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Artwork Price
                                <asp:RequiredFieldValidator ID="RequiredPriceValidator" ControlToValidate="txtPrice" runat="server" ErrorMessage="Artwork Price is required" Text="*" CssClass="text-danger"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="RangeValidatorPrice" Type="Double" ControlToValidate="txtPrice" runat="server" ErrorMessage="This is not a valid price" Text="*" CssClass="text-danger" MinimumValue="0.00"></asp:RangeValidator>
                            </label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="0.00" TextMode="Number" ID="txtPrice" min="0"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-6">
                            <label>
                                Stock Available
                                <asp:RequiredFieldValidator ID="RequiredStockQtyValidator1" ControlToValidate="txtStockQty" runat="server" ErrorMessage="Stock Quantity is required" Text="*" CssClass="text-danger"></asp:RequiredFieldValidator>
                                <asp:CustomValidator ID="CustomValidatorStockQty" runat="server" ErrorMessage="" Text="*" ControlToValidate="txtStockQty" OnServerValidate="CustomValidatorStockQty_ServerValidate"></asp:CustomValidator>
                            </label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="Stock Available" TextMode="Number" ID="txtStockQty" min="0" ></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-12">
                            <label>
                                Description
                                <asp:RequiredFieldValidator ID="RequiredDescValidator1" ControlToValidate="txtDesc" runat="server" ErrorMessage="Description for artwork is required" Text="*" CssClass="text-danger"></asp:RequiredFieldValidator>
                            </label>
                            <asp:TextBox runat="server" CssClass="form-control" TextMode="Multiline" ID="txtDesc" MaxLength="200"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-12">
                            <div class="form-check form-check-inline">
                                <asp:CheckBox runat="server" ID="cIsVisible" CssClass="form-check-input" Checked="true" />
                                <label class="form-check-label" for="Content_Content_cIsVisible">Visible by Customer</label>
                            </div>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-12">
                            <label>Artwork Image</label>
                            <asp:FileUpload runat="server" CssClass="form-control" ID="FileUpload" AllowMultiple="false" accept="image/*"/>
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
</asp:Content>
<asp:Content ContentPlaceHolderID="VendorScript" runat="server" ID="script">
    <script>
        document.querySelector("#Content_Content_FileUpload").addEventListener('change', (e) => {
            const img = document.querySelector("#img")
            img.src = URL.createObjectURL(e.target.files[0])
            img.classList.remove("d-none")
        })
    </script>
</asp:Content>