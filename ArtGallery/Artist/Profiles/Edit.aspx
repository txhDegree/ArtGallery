<%@ Page Title="" Language="C#" MasterPageFile="~/Artist/Navbar.master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="ArtGallery.Artist.Profiles.Edit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="VendorStyle" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="title" runat="server">Edit Profile</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
    <h1 class="h3 mb-4 text-gray-800">Create New Artwork</h1>
    <div class="row">
        <div class="col-md-6 mx-auto">
            <div class="card">
                <div class="card-body">
                    <% if (isUpdated) { %>
                    <div class="alert alert-success">
                        Your profile is updated successfully!
                    </div>
                    <% } %>
                    <div class="form-row">
                        <div class="form-group col-12">
                            <label>
                                Date Of Birth
                                <asp:RangeValidator ID="RangeValidatorDOB" runat="server" ErrorMessage="Your Date Of Birth is invalid" Text="*" Type="Date" ControlToValidate="txtDOB" CssClass="text-danger" MinimumValue="1/1/1900"></asp:RangeValidator>
                            </label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="Date Of Birth" ID="txtDOB" MaxLength="10" TextMode="Date"></asp:TextBox>
                        </div>
                        <div class="form-group col-12">
                            <label>About Yourself</label>
                            <asp:TextBox runat="server" CssClass="form-control" placeholder="Tell Us More About Yourself..." ID="txtAbtMe" TextMode="MultiLine" Rows="4" ></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-12">
                            <label>Artwork Image</label>
                            <asp:FileUpload runat="server" CssClass="form-control" ID="FileUpload" AllowMultiple="false" accept="image/*"/>
                        </div>
                    </div>
                    <div class="col-12 d-flex justify-content-center align-items-center">
                        <img src="<%= ImgSrc %>" alt="" style="max-height: 300px; max-width: 300px;" id="img" />
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
<asp:Content ID="Content4" ContentPlaceHolderID="VendorScript" runat="server">
    <script>
        document.querySelector("#Content_Content_FileUpload").addEventListener('change', (e) => {
            const img = document.querySelector("#img")
            img.src = URL.createObjectURL(e.target.files[0])
        })
    </script>
</asp:Content>