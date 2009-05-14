module Webby
  class Builder
    # Horrible monkeypatch, forgive me :'(
    alias_method :original_run, :run

    def run( opts = {} )
      puts "The ugly before"
      original_run(opts)
      puts "The lovely after"
      display_tags
    end

    def display_tags
      posts = Resources.pages.find(:all,
                :in_directory => '/',
                :recursive => true,
                :blog_post => true)

      tags = posts.map{|p| p.tags}.flatten.uniq.each do |tag|
        dir = Webby.site.tags_dir
        p dir
        page = File.join(dir, File.basename(tag))
        p page
        page = Webby::Builder.create(page,
                :from => "#{Webby.site.template_dir}/blog/tag.erb",
                :locals => {:tag => tag, :directory => dir})

      end
    end
  end
end
