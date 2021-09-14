<%@ Page Title="" Language="C#" MasterPageFile="~/main.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="ArtGallery.index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MasterStyle" runat="server">
    <link href="/public/index.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterTitle" runat="server">Art Gallery</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Content" runat="server">
    <!-- Navigation-->
        <nav class="navbar navbar-expand-lg bg-gradient-dark fixed-top py-2" id="mainNav">
            <div class="container">
                <a class="navbar-brand" href="/index.aspx"><img src="/public/img/logo.png" alt="Logo" /></a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                    Menu
                    <i class="fas fa-bars ms-1"></i>
                </button>
                <div class="collapse navbar-collapse" id="navbarResponsive">
                    <ul class="navbar-nav text-uppercase ms-auto py-4 py-lg-0">
                        <li class="nav-item"><a class="nav-link" href="#services">Services</a></li>
                        <li class="nav-item"><a class="nav-link" href="#artworks">Artworks Gallery</a></li>
                        <li class="nav-item"><a class="nav-link" href="#about">About</a></li>
                        <li class="nav-item"><a class="nav-link" href="#team">Team</a></li>
                    </ul>
                </div>
                <% if(isLoggedIn) { 
                    switch(role){
                        case "Customer":
                    %>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav text-uppercase ms-auto py-4 py-lg-0">
                        <li class="nav-item"><a class="nav-link" href="/Customer/Dashboard.aspx">Customer Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="/Customer/Carts/List.aspx">My Cart</a></li>
                        <li class="nav-item"><a class="nav-link" href="/Customer/Orders/List.aspx">My Order</a></li>
                    </ul>
                </div>
                <div class="ml-auto">
                    <ul class="navbar-nav text-uppercase ms-auto py-4 py-lg-0">
                        <li class="nav-item"><asp:LinkButton ID="logoutBtn" CssClass="nav-link" runat="server" OnClick="logoutBtn_Click">Logout</asp:LinkButton></li>
                    </ul>
                </div>
                <% 
                        break;
                        case "Artist":
                %>
                    <div class="collapse navbar-collapse">
                        <ul class="navbar-nav text-uppercase ms-auto py-4 py-lg-0">
                            <li class="nav-item"><a class="nav-link" href="/Artist/Artworks/List.aspx">My Artworks</a></li>
                            <li class="nav-item"><a class="nav-link" href="/Artist/Orders/List.aspx">My Order</a></li>
                        </ul>
                    </div>
                    <div class="ml-auto">
                        <ul class="navbar-nav text-uppercase ms-auto py-4 py-lg-0">
                            <li class="nav-item"><asp:LinkButton ID="LinkButton1" CssClass="nav-link" runat="server" OnClick="logoutBtn_Click">Logout</asp:LinkButton></li>
                        </ul>
                    </div>
                <% 
                        break;
                    }
                %>
                <%  } else { %>
                <div class="ml-auto">
                    <ul class="navbar-nav text-uppercase ms-auto py-4 py-lg-0">
                        <li class="nav-item"><a class="nav-link" href="/login.aspx">Login</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" id="dropdownMenuButton2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                Sign Up
                            </a>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenuButton2">
                                <a class="dropdown-item" href="/Customer/register.aspx">Customer</a>
                                <a class="dropdown-item" href="/Artist/register.aspx">Artist</a>
                            </div>
                        </li>
                    </ul>
                </div>
                <% } %>
            </div>
        </nav>
        <!-- Masthead-->
        <header class="masthead">
            <div class="container">
                <div class="masthead-subheading">Welcome To Art Gallery!</div>
                <div class="masthead-heading text-uppercase">It's Nice To Meet You</div>
                <a class="btn btn-warning btn-xl text-uppercase" href="#services">Tell Me More</a>
            </div>
        </header>
        <!-- Services-->
        <section class="page-section" id="services">
            <div class="container">
                <div class="text-center">
                    <h2 class="section-heading text-uppercase">Services</h2>
                    <h3 class="section-subheading text-muted">These are the services we provide. Join us to know more!</h3>
                </div>
                <div class="row text-center">
                    <div class="col-md-4">
                        <span class="fa-stack fa-4x">
                            <i class="fas fa-circle fa-stack-2x text-warning"></i>
                            <i class="fas fa-shopping-cart fa-stack-1x fa-inverse"></i>
                        </span>
                        <h4 class="my-3">E-Commerce</h4>
                        <p class="text-muted">Register as our customer! Purchase the artworks you love!</p>
                        <a href="/Customer/register.aspx" class="btn btn-primary">Register Now!</a>
                    </div>
                    <div class="col-md-4">
                        <span class="fa-stack fa-4x">
                            <i class="fas fa-circle fa-stack-2x text-warning"></i>
                            <i class="fas fa-laptop fa-stack-1x fa-inverse"></i>
                        </span>
                        <h4 class="my-3">Be Our Partner</h4>
                        <p class="text-muted">You can also sell your artwork on our platform! It's easy to start!</p>
                        <a href="/Artist/register.aspx" class="btn btn-primary">Register Now!</a>
                    </div>
                    <div class="col-md-4">
                        <span class="fa-stack fa-4x">
                            <i class="fas fa-circle fa-stack-2x text-warning"></i>
                            <i class="fas fa-lock fa-stack-1x fa-inverse"></i>
                        </span>
                        <h4 class="my-3">Web Security</h4>
                        <p class="text-muted">Your information on our website is safe and secure!</p>
                    </div>
                </div>
            </div>
        </section>
        <!-- Portfolio Grid-->
        <section class="page-section bg-light" id="artworks">
            <div class="container">
                <div class="text-center">
                    <h2 class="section-heading text-uppercase">Artworks Gallery</h2>
                    <h3 class="section-subheading text-muted"><a href="/Artworks/List.aspx">View More Artworks</a></h3>
                </div>
                <div class="row d-flex justify-content-center align-items-center">
                    <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1" >
                        <ItemTemplate>
                            <div class="col-lg-4 col-sm-6 mb-4">
                                <!-- Portfolio item 1-->
                                <div class="portfolio-item">
                                    <a class="portfolio-link" href='/Artworks/Details.aspx?Id=<%# Eval("Id") %>'>
                                        <div class="portfolio-hover">
                                            <div class="portfolio-hover-content"><i class="fas fa-eye fa-3x"></i></div>
                                        </div>
                                        <img class="img-fluid" src='<%# Convert.IsDBNull(Eval("Image")) ? "/public/img/image.svg" : "/Storage/Artworks/" + Eval("Image").ToString() %>' alt='<%# Eval("Title") %>' />
                                    </a>
                                    <div class="portfolio-caption">
                                        <div class="portfolio-caption-heading"><%# Eval("Title") %></div>
                                        <div class="portfolio-caption-subheading text-muted"><%# Eval("Description") %></div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ArtDBConnStr %>" SelectCommand="SELECT TOP 6 * FROM [Artworks] WHERE ([isVisible] = @isVisible) ORDER BY [Id] DESC">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="1" Name="isVisible" Type="Byte" />
                    </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
        </section>
        <!-- About-->
        <section class="page-section" id="about">
            <div class="container">
                <div class="text-center">
                    <h2 class="section-heading text-uppercase">About</h2>
                    <h3 class="section-subheading text-muted">This is how this platform started</h3>
                </div>
                <ul class="timeline">
                    <li>
                        <div class="timeline-image"><img class="rounded-circle img-fluid" src="/public/img/about/1.jpg" alt="..." /></div>
                        <div class="timeline-panel">
                            <div class="timeline-heading">
                                <h4>2019-2020</h4>
                                <h4 class="subheading">Our Humble Beginnings</h4>
                            </div>
                            <div class="timeline-body"><p class="text-muted">4 of the core team members meet in Tunku Abdul Rahman University College, study in the same course and decide to start a business together!</p></div>
                        </div>
                    </li>
                    <li class="timeline-inverted">
                        <div class="timeline-image"><img class="rounded-circle img-fluid" src="/public/img/about/2.jpg" alt="..." /></div>
                        <div class="timeline-panel">
                            <div class="timeline-heading">
                                <h4>December 2020</h4>
                                <h4 class="subheading">An Agency is Born</h4>
                            </div>
                            <div class="timeline-body"><p class="text-muted">We started to build our profile on social media to attract public's attention on our platform.</p></div>
                        </div>
                    </li>
                    <li>
                        <div class="timeline-image"><img class="rounded-circle img-fluid" src="/public/img/about/3.jpg" alt="..." /></div>
                        <div class="timeline-panel">
                            <div class="timeline-heading">
                                <h4>June 2021</h4>
                                <h4 class="subheading">Transition to Full Service</h4>
                            </div>
                            <div class="timeline-body"><p class="text-muted">Throught the year, we have added may different features to enhance customer experience when using this platform.</p></div>
                        </div>
                    </li>
                    <li class="timeline-inverted">
                        <div class="timeline-image">
                            <h4>
                                Be Part
                                <br />
                                Of Our
                                <br />
                                Story!
                            </h4>
                        </div>
                    </li>
                </ul>
            </div>
        </section>
        <!-- Team-->
        <section class="page-section bg-light" id="team">
            <div class="container">
                <div class="text-center">
                    <h2 class="section-heading text-uppercase">Our Amazing Team</h2>
                    <h3 class="section-subheading text-muted">Lorem ipsum dolor sit amet consectetur.</h3>
                </div>
                <div class="row">
                    <div class="col-lg-3">
                        <div class="team-member">
                            <img class="mx-auto rounded-circle" src="/public/img/team/TAN XU HENG.png" alt="TAN XU HENG" />
                            <h4>TAN XU HENG</h4>
                            <p class="text-muted">CEO</p>
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="team-member">
                            <img class="mx-auto rounded-circle" src="/public/img/team/SIAK SHIAO YUAN.jpg" alt="SIAO SHIAO YUAN" />
                            <h4>SIAK SHIAO YUAN</h4>
                            <p class="text-muted">Lead Developer</p>
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="team-member">
                            <img class="mx-auto rounded-circle" src="/public/img/team/GAN KIAN YANG.jpg" alt="GAN KIAN YANG" />
                            <h4>GAN KIAN YANG</h4>
                            <p class="text-muted">Lead Marketer</p>
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="team-member">
                            <img class="mx-auto rounded-circle" src="/public/img/team/KAU JING TONG.png" alt="KAU JING TONG" />
                            <h4>KAU JING TONG</h4>
                            <p class="text-muted">Lead Designer</p>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-8 mx-auto text-center"><p class="large text-muted">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Aut eaque, laboriosam veritatis, quos non quis ad perspiciatis, totam corporis ea, alias ut unde.</p></div>
                </div>
            </div>
        </section>

        <!-- Footer-->
        <footer class="footer py-4">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-4 text-lg-start">Copyright</div>
                    <div class="col-lg-4 my-3 my-lg-0">&copy;</div>
                    <div class="col-lg-4 text-lg-end">Art Gallery</div>
                </div>
            </div>
        </footer>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MasterScript" runat="server">
</asp:Content>
