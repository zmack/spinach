module Webby
  class Builder
    # Horrible monkeypatch, forgive me :'(
    alias_method :original_run, :run

    def run( opts = {} )
      ::Webby.load_files
      opts.delete(:load_files)

      create_tags_templates
      original_run(opts)
    end

    def create_tags_templates
      posts = Resources.pages.find(:all, :in_directory => '/', :recursive => true, :blog_post => true)

      dir = Webby.site.tags_dir
      FileUtils.rm( Dir.glob("content/#{dir}/*") )

      tags = posts.map{|p| p.tags}.flatten.uniq.compact.each do |tag|
        page = File.join(dir, File.basename(tag.to_url))
        journal.create(page)
        page = Webby::Builder.create(page,
                :from => "#{Webby.site.template_dir}/blog/tag.erb",
                :locals => {:tag => tag, :directory => dir})

      end
    end
  end
end
