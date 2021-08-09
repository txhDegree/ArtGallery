<%@ Page Title="" Language="C#" MasterPageFile="~/Artist/Navbar.master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="ArtGallery.Artist.Artworks.Edit" %>
<asp:Content ID="title" ContentPlaceHolderID="title" runat="server">Create New Artwork - Artist</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">Edit My Artwork <asp:Label runat="server" ID="txtId" CssClass="badge badge-info"></asp:Label></h1>
    <div class="row">
        <div class="col-sm-6 mx-auto">
            <div class="card">
                <div class="card-body">
                    <% if (isUpdated) { %>
                    <div class="alert alert-success">
                        This artwork is updated successfully!
                    </div>
                    <% } %>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Artwork Title</label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="Artwork Title" ID="txtTitle" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-6">
                            <label>Year Created</label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="Year Created" MaxLength="4" ID="txtYear" ></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Artwork Price</label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="0.00" TextMode="Number" ID="txtPrice" min="0"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-6">
                            <label>Stock Available</label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="Stock Available" TextMode="Number" ID="txtStockQty" min="0" ></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-12">
                            <label>Description</label>
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
                    <div class="col-12 d-flex justify-content-center align-items-center">
                        <img src="" alt="" style="max-height: 300px; max-width: 300px;" class="d-none" id="img" />
                    </div>
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