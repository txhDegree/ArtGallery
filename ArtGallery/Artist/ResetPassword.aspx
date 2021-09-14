<%@ Page Title="" Language="C#" MasterPageFile="~/Artist/Navbar.master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="ArtGallery.Artist.ResetPassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="VendorStyle" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="title" runat="server">Reset Password
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
    <asp:ChangePassword ID="ChangePassword1" runat="server" RenderOuterTable="false" >
        <ChangePasswordTemplate>
            <h1 class="h3 mb-4 text-gray-800">Reset Password</h1>
            <div class="row">
                <div class="col-md-6 mx-auto">
                    <div class="card">
                        <div class="card-body">
                            <div class="form-group">
                                <asp:Label ID="CurrentPasswordLabel" runat="server" AssociatedControlID="CurrentPassword">Password:</asp:Label>
                                <asp:RequiredFieldValidator ID="CurrentPasswordRequired" CssClass="text-danger" runat="server" ControlToValidate="CurrentPassword" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                <asp:TextBox ID="CurrentPassword" CssClass="form-control" runat="server" TextMode="Password"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="NewPasswordLabel" runat="server" AssociatedControlID="NewPassword">New Password:</asp:Label>
                                <asp:RequiredFieldValidator ID="NewPasswordRequired" CssClass="text-danger" runat="server" ControlToValidate="NewPassword" ErrorMessage="New Password is required." ToolTip="New Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                <asp:TextBox ID="NewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="ConfirmNewPasswordLabel" runat="server" AssociatedControlID="ConfirmNewPassword">Confirm New Password:</asp:Label>
                                <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" CssClass="text-danger" runat="server" ControlToValidate="ConfirmNewPassword" ErrorMessage="Confirm New Password is required." ToolTip="Confirm New Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                <asp:TextBox ID="ConfirmNewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>
                            <asp:CompareValidator ID="NewPasswordCompare" CssClass="text-danger" runat="server" ControlToCompare="NewPassword" ControlToValidate="ConfirmNewPassword" Display="Dynamic" ErrorMessage="The Confirm New Password must match the New Password entry." ValidationGroup="ChangePassword1"></asp:CompareValidator>
                            <p class="text-danger">
                                <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                            </p>
                            <div class="btn-group">
                                <asp:Button ID="CancelPushButton" runat="server" CssClass="btn btn-secondary" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                                <asp:Button ID="ChangePasswordPushButton" runat="server" CssClass="btn btn-success" CommandName="ChangePassword" Text="Change Password" ValidationGroup="ChangePassword1" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ChangePasswordTemplate>
        <SuccessTemplate>
            <h1 class="h3 mb-4 text-gray-800">Reset Password Complete</h1>
            <div class="row">
                <div class="col-md-6 mx-auto">
                    <div class="card">
                        <div class="card-body">
                            <div class="alert alert-success">Your password has been changed!</div>
                        </div>
                    </div>
                </div>
            </div>
        </SuccessTemplate>
    </asp:ChangePassword>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="VendorScript" runat="server">
</asp:Content>
