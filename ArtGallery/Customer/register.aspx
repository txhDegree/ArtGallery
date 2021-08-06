<%@ Page Title="" Language="C#" MasterPageFile="~/main.Master" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="ArtGallery.Customer.register" %>
<asp:Content ID="Style" ContentPlaceHolderID="MasterStyle" runat="server">
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="MasterScript" runat="server">
    <script defer>
        document.querySelector('body').classList.add('bg-gradient-danger');
    </script>
</asp:Content>
<asp:Content ID="title" ContentPlaceHolderID="MasterTitle" runat="server">Register - Customer</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="Content" runat="server">
    <div class="container">
        <div class="card o-hidden border-0 shadow-lg my-5">
            <div class="card-body p-0">
                <!-- Nested Row within Card Body -->
                <div class="row">
                    <div class="col-lg-5 d-none d-lg-block bg-register-image"></div>
                    <div class="col-lg-7">
                        <div class="p-5">
                            <div class="text-center">
                                <h1 class="h4 text-gray-900 mb-4">Looking for Beautiful Artworks?<br />Create Your Customer Account!</h1>
                            </div>
                            <asp:CreateUserWizard ID="CreateUserWizard1" runat="server" CreateUserButtonText="Register Account" CreateUserButtonStyle-CssClass="btn btn-primary btn-user btn-block" CssClass="mx-auto" LoginCreatedUser="False" OnCreatedUser="CreateUserWizard1_CreatedUser">
                                <WizardSteps>
                                    <asp:CreateUserWizardStep runat="server" ID="CreateUserWizardStep1">
                                        <ContentTemplate>
                                            <div class="form-group">
                                                <asp:TextBox runat="server" ID="UserName" CssClass="form-control form-control-user" placeholder="Username" ></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                                    ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="CreateUserWizard1" CssClass="text-danger">*</asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group">
                                                <asp:TextBox runat="server" ID="Email" TextMode="Email" CssClass="form-control form-control-user" placeholder="Email Address" ></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="Email"
                                                    ErrorMessage="E-mail is required." ToolTip="E-mail is required." ValidationGroup="CreateUserWizard1" CssClass="text-danger">*</asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group row">
                                                <div class="col-sm-6 mb-3 mb-sm-0">
                                                    <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control form-control-user" placeholder="Password"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                                        ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="CreateUserWizard1" CssClass="text-danger">*</asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-sm-6">
                                                    <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" CssClass="form-control form-control-user" placeholder="Repeat Password"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                                                        ErrorMessage="Confirm Password is required." ToolTip="Confirm Password is required."
                                                        ValidationGroup="CreateUserWizard1" CssClass="text-danger">*</asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-12">
                                                    <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password"
                                                        ControlToValidate="ConfirmPassword" Display="Dynamic" ErrorMessage="The Password and Confirmation Password must match."
                                                        ValidationGroup="CreateUserWizard1" CssClass="text-danger"></asp:CompareValidator>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:DropDownList runat="server" ID="Question" CssClass="form-control form-control-user">
                                                    <asp:ListItem>-- Select Your Security Question --</asp:ListItem>
                                                    <asp:ListItem>In what city were you born?</asp:ListItem>
                                                    <asp:ListItem>What is the name of your favorite pet?</asp:ListItem>
                                                    <asp:ListItem>What is your mother&#39;s maiden name?</asp:ListItem>
                                                    <asp:ListItem>What high school did you attend?</asp:ListItem>
                                                    <asp:ListItem>What is the name of your first school?</asp:ListItem>
                                                    <asp:ListItem>What was the make of your first car?</asp:ListItem>
                                                    <asp:ListItem>What was your favorite food as a child?</asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="QuestionRequired" runat="server" ControlToValidate="Question"
                                                    ErrorMessage="Security question is required." ToolTip="Security question is required."
                                                    ValidationGroup="CreateUserWizard1" CssClass="text-danger">*</asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group">
                                                <asp:TextBox runat="server" ID="Answer" CssClass="form-control form-control-user" placeholder="Answer"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="AnswerRequired" runat="server" ControlToValidate="Answer"
                                                    ErrorMessage="Security answer is required." ToolTip="Security answer is required."
                                                    ValidationGroup="CreateUserWizard1" CssClass="text-danger">*</asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group text-danger">
                                                <asp:Literal ID="ErrorMessage" runat="server" EnableViewState="False"></asp:Literal>
                                            </div>
                                        </ContentTemplate>
                                    </asp:CreateUserWizardStep>
                                    <asp:CompleteWizardStep ID="CompleteWizardStep1" runat="server">
                                        <ContentTemplate>
                                            <div class="alert alert-success">Your account has been successfully created.</div>
                                            <div>
                                                <a class="btn btn-primary btn-block" href="/login.aspx" />Login Now</a>
                                            </div>
                                        </ContentTemplate>
                                    </asp:CompleteWizardStep>
                                </WizardSteps>
                            </asp:CreateUserWizard>
                            <hr>
                            <!-- <div class="text-center">
                                <a class="small" href="forgot-password.html">Forgot Password?</a>
                            </div> -->
                            <div class="text-center">
                                <a class="small" href="/login.aspx">Already have an account? Login!</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>