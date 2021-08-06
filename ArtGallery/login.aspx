<%@ Page Title="" Language="C#" MasterPageFile="~/main.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="ArtGallery.Artist.WebForm1" %>
<asp:Content ID="Style" ContentPlaceHolderID="MasterStyle" runat="server">

</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="MasterScript" runat="server">
    <script defer>
        document.querySelector('body').classList.add('bg-gradient-primary');
    </script>
</asp:Content>
<asp:Content ID="title" ContentPlaceHolderID="MasterTitle" runat="server">Login Your Art Gallery Account</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="Content" runat="server">
    <div class="container">
        <!-- Outer Row -->
        <div class="row justify-content-center">
            <div class="col-xl-10 col-lg-12 col-md-9">
                <div class="card o-hidden border-0 shadow-lg my-5">
                    <div class="card-body p-0">
                        <!-- Nested Row within Card Body -->
                        <div class="row">
                            <div class="col-lg-6 d-none d-lg-block bg-login-image"></div>
                            <div class="col-lg-6">
                                <div class="p-5">
                                    <div class="text-center">
                                        <h1 class="h4 text-gray-900 mb-4">Welcome Back!</h1>
                                    </div>
                                    <asp:Login ID="Login1" runat="server" RenderOuterTable="false" OnLoggedIn="Login1_LoggedIn">
                                        <LayoutTemplate>
                                            <div class="form-group">
                                                <asp:TextBox ID="UserName" runat="server" CssClass="form-control form-control-user" placeholder="Enter UserName..."></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="Login1" CssClass="text-danger">*</asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group">
                                                <asp:TextBox ID="Password" runat="server" TextMode="Password" CssClass="form-control form-control-user" placeholder="Password"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="Login1" CssClass="text-danger">*</asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group text-danger">
                                                <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                            </div>
                                            <!-- <asp:CheckBox ID="RememberMe" runat="server" Text="Remember me next time." /> -->
                                            <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Login" ValidationGroup="Login1" CssClass="btn btn-primary btn-user btn-block" />
                                        </LayoutTemplate>
                                    </asp:Login>
                                    <hr>
                                    <!-- <div class="text-center">
                                        <a class="small" href="forgot-password.html">Forgot Password?</a>
                                    </div> -->
                                    <div class="text-center">
                                        <a class="small" href="/Customer/register.aspx">Create a Customer Account!</a>
                                    </div>
                                    <div class="text-center">
                                        <a class="small" href="/Artist/register.aspx">Create an Artist Account!</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>