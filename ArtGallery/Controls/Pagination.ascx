<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Pagination.ascx.cs" Inherits="ArtGallery.Controls.Pagination" %>
<div>
    <nav>
        <ul class="pagination">
            <li class="page-item <%= CurrentPage == 1 ? "disabled" : "" %>">
                <a class="page-link" href="<%= RedirectUrl + "page=" + (CurrentPage-1) %>" tabindex="-1">Previous</a>
            </li>
            <% for(int i = StartingPage ; i <= EndingPage; i++) { %>
                <li class="page-item <%= CurrentPage == i ? "disabled" : "" %>">
                    <a class="page-link" href="<%= RedirectUrl + "page=" + i %>"><%= i %></a>
                </li>
            <% } %>
            <!-- <li class="page-item active"><a class="page-link" href="#">2</a></li> -->
            <li class='page-item <%= CurrentPage == TotalPage ? "disabled" : "" %>'>
                <a class="page-link" href="<%= RedirectUrl + "page=" + (CurrentPage+1) %>">Next</a>
            </li>
        </ul>
    </nav>
    <p class="text-center">Showing <b><%= CurrentRecord %></b> out of <b><%= TotalRecord %></b></p>
</div>