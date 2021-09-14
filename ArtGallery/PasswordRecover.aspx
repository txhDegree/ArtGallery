<%@ Page Title="" Language="C#" MasterPageFile="~/main.Master" AutoEventWireup="true" CodeBehind="PasswordRecover.aspx.cs" Inherits="ArtGallery.PasswordRecover" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MasterStyle" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterTitle" runat="server">Password Recovery</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
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
                                    <asp:PasswordRecovery ID="PasswordRecovery1" runat="server" RenderOuterTable="false">
                                        <UserNameTemplate>
                                            <div class="text-center">
                                                <h1 class="h4 text-gray-900 mb-4">Password Recovery</h1>
                                            </div>
                                            <p>Forgot Your Password? Enter your User Name to receive your password.</p>
                                            <div class="form-group">
                                                <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User Name:</asp:Label>
                                                <asp:TextBox ID="UserName" runat="server" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="UserNameRequired" CssClass="text-danger" runat="server" ControlToValidate="UserName" ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="PasswordRecovery1">*</asp:RequiredFieldValidator>
                                            </div>
                                            <div class="alert alert-danger" runat="server">
                                                <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                            </div>
                                            <div>
                                                <asp:Button ID="SubmitButton" runat="server" CommandName="Submit" Text="Submit" ValidationGroup="PasswordRecovery1" CssClass="btn btn-success" />
                                            </div>
                                        </UserNameTemplate>
                                        <QuestionTemplate>
                                            <div class="text-center">
                                                <h1 class="h4 text-gray-900 mb-4">Identity Confirmation</h1>
                                            </div>
                                            <p>Answer the following question to receive your password.</p>
                                            <h6>
                                                User Name: <label><asp:Literal ID="UserName" runat="server"></asp:Literal></label>
                                            </h6>
                                            <h6>
                                                Question: <label><asp:Literal ID="Question" runat="server"></asp:Literal></label>
                                            </h6>
                                            <div class="form-group">
                                                <asp:Label ID="AnswerLabel" runat="server" AssociatedControlID="Answer">Answer:</asp:Label>
                                                <asp:TextBox ID="Answer" runat="server" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="AnswerRequired" CssClass="text-danger" runat="server" ControlToValidate="Answer" ErrorMessage="Answer is required." ToolTip="Answer is required." ValidationGroup="PasswordRecovery1">*</asp:RequiredFieldValidator>
                                            </div>
                                            <div class="alert alert-danger">
                                                <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                            </div>
                                            <div>
                                                <asp:Button ID="SubmitButton" runat="server" CssClass="btn btn-success" CommandName="Submit" Text="Submit" ValidationGroup="PasswordRecovery1" />
                                            </div>
                                        </QuestionTemplate>
                                        <SuccessTemplate>
                                            <div class="alert alert-success">
                                                Your password has been sent to you via Email. The mail might be in your SPAM mail box.
                                            </div>
                                        </SuccessTemplate>
                                    </asp:PasswordRecovery>
                                    <hr>
                                    <div class="text-center">
                                        <a class="small" href="/Customer/register.aspx">Create a Customer Account!</a>
                                    </div>
                                    <div class="text-center">
                                        <a class="small" href="/Artist/register.aspx">Create an Artist Account!</a>
                                    </div>
                                    <div class="text-center">
                                        <a class="small" href="/login.aspx">Login</a>
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
<asp:Content ID="Content4" ContentPlaceHolderID="MasterScript" runat="server">
</asp:Content>
