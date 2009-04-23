module Webby
  class Builder
    alias_method :original_run, :run

    def run( opts = {} )
      original_run(opts)
      puts "Goodbye moto"
      Resources.pages.each do |file|
        p file.tags
      end
    end
  end
end
