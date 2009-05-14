require 'rubygems'
require 'datamapper'
require 'webby'

DataMapper.setup(:default, 'mysql://root@localhost/mephisto')

class Tagging
  include DataMapper::Resource
  property :id, Serial

  belongs_to :taggable
  belongs_to :tag
end

class Tag
  include DataMapper::Resource
  property :id, Serial
  property :name, String
end

class Content
  include DataMapper::Resource
  property :id, Integer, :serial => true
  property :title, String
  property :body, String
  property :type, String
  property :site_id, Integer
  property :created_at, DateTime

  has n, :taggings, :child_key => [:taggable_id]
  has n, :tags, :through => :taggings
end


def format_article(article)
<<-EOF
---
title: #{article.title}
created_at: #{article.created_at.to_time.to_yaml.slice(4..-1).strip}
blog_post: true
filter:
  - tidy
layout:
  - post
tags:
#{article.taggings.tag.map {|t| "  - #{t.name}\n"}}
---
#{article.body}
EOF
end

def create_post_file(article)
  file_path = "content/#{article.created_at.year}/#{article.created_at.month}/#{article.created_at.day}"
  filename = "#{article.title.to_url}.txt"

  FileUtils.mkdir_p(file_path)

  File.open(File.join(file_path, filename), "w+") do |file|
    file.write format_article(article)
  end
end
