---
title:      04
created_at: 2009-04-21 14:41:59.027082 +03:00
filter:     erb
dirty:      true
extension:  js
layout:     false
---
<%
  articles = @pages.find(:all, :in_directory => '/', :recursive => true, :sort_by => "created_at", :reverse => true, :blog_post => true)
%>
Spinach = {
  posts: [
    <%= articles.map do |article|
        %({ title: "#{article.title}", tags: "#{article.tags.join(',')}", url: "#{url_for(article)}" })
      end.join(",\n  ")
    %>
  ]
}
