module Webby::Apps
  class Generator
    alias_method :original_create_site, :create_site

    def create_site
      puts "Hello moto"
      original_create_site
      puts "Goodbye moto"
    end
  end
end
