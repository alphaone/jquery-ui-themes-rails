namespace :jquery_ui_themes do
  namespace :import do
    desc 'Import jQuery themeroller theme'
    task :themeroller, [:path, :name] => :environment do |t, args|
      abort 'Please specify a path to the file to import' if args[:path].blank?
      abort 'Please specify a name' if args[:name].blank?
      
      require 'fileutils'
      
      begin
        css_file = File.open(File.expand_path(args[:path]), 'r')
      rescue
        abort ('Import file not found!')
      end
      
      FileUtils.mkdir_p(File.expand_path('./app/assets/stylesheets/jquery-ui/'))
      FileUtils.mkdir_p(File.expand_path('./app/assets/images/jquery-ui/' + args[:name]))
      
      css = File.read(css_file)
      
      File.open(File.expand_path("./app/assets/stylesheets/jquery-ui/#{args[:name]}.css.scss"), "w") do |file| 
        file.puts css.gsub(/url\(images\/(.*)\)/, 'url(image-path(\'jquery-ui/' + args[:name] + '/\1\'))')
      end
      
      FileUtils.cp_r(File.dirname(css_file) + '/images/.', File.expand_path('./app/assets/images/jquery-ui/' + args[:name]))
    end
    
    desc 'Import themes from Google CDN'
    task :google_cdn, [:version, :theme] => :environment do |t, args|
      abort 'Please specify a version to import' if args[:version].blank?
      abort 'Please specify a theme to import' if args[:theme].blank?

      if args[:theme] == 'all'
        JqueryUiThemes::GoogleCDN.download_all(args[:version])
      else
        JqueryUiThemes::GoogleCDN.download(args[:theme], args[:version])
      end
    end
  end
end
