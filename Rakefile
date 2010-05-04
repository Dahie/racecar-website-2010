# -*- ruby -*-
#
# This is a sample Rakefile to which you can add tasks to manage your website. For example, users
# may use this file for specifying an upload task for their website (copying the output to a server
# via rsync, ftp, scp, ...).
#
# It also provides some tasks out of the box, for example, rendering the website, clobbering the
# generated files, an auto render task,...
#

require 'webgen/webgentask'
require 'webgen/website'
require 'RMagick'
require 'net/ftp'

task :default => :webgen

webgen_config = lambda do |config|
  # you can set configuration options here
end

Webgen::WebgenTask.new do |website|
  website.clobber_outdir = true
  website.config_block = webgen_config
end

desc "Show outdated translations"
task :outdated do
  puts "Listing outdated translations"
  puts
  puts "(Note: Information is taken from the last webgen run. To get the"
  puts "       useful information, run webgen once before this task!)"
  puts

  website = Webgen::Website.new(Dir.pwd, Webgen::Logger.new($stdout), &webgen_config)
  website.execute_in_env do
    website.init
    website.tree.node_access[:acn].each do |acn, versions|
      main = versions.find {|v| v.lang == website.config['website.lang']}
      next unless main
      outdated = versions.select do |v|
         main != v && main['modified_at'] > v['modified_at']
      end.map {|v| v.lang}.join(', ')
      puts "ACN #{acn}: #{outdated}" if outdated.length > 0
    end
  end
end

desc "Render the website automatically on changes"
task :auto_webgen do
  puts 'Starting auto-render mode'
  time = Time.now
  abort = false
  old_paths = []
  Signal.trap('INT') {abort = true}

  while !abort
    # you may need to adjust the glob so that all your sources are included
    paths = Dir['src/**/*'].sort
    if old_paths != paths || paths.any? {|p| File.mtime(p) > time}
      begin
        Rake::Task['webgen'].execute({})
      rescue Webgen::Error => e
        puts e.message
      end
    end
    time = Time.now
    old_paths = paths
    sleep 2
  end
end

def ftp_files(prefixToRemove, sourceFileList, targetDir, hostname, username, password)
  Net::FTP.open(hostname, username, password) do |ftp|
    begin
      puts "Creating dir #{targetDir}" 
      ftp.mkdir targetDir
    rescue 
      puts $!
    end
    sourceFileList.each do |srcFile|    
      if prefixToRemove
        targetFile = srcFile.pathmap(("%{^#{prefixToRemove},#{targetDir}}p")) 
      else
        targetFile = srcFile.pathmap("#{targetDir}%s%p")
      end
      begin
        puts "Creating dir #{targetFile}" if File.directory?(srcFile)
        ftp.mkdir targetFile if File.directory?(srcFile)
      rescue 
        puts $!
      end
      begin
        puts "Copying #{srcFile} -> #{targetFile}" unless File.directory?(srcFile)
        ftp.putbinaryfile(srcFile, targetFile) unless File.directory?(srcFile)
      rescue 
        puts $!
      end
    end
  end
end

desc "Regenerate the website and upload to the server"
task :deploy => [:cleanup, :webgen, 'generate:thumbnails'] do
  #task :deploy => [:dist] do
  puts 'Please enter the FTP password'
  password = STDIN.gets.chomp
  ftp_files("out", FileList["out/**/*"], "", 'ftp.racecarf1.com', 'racecarf1.com', password)
end

desc "Deletes existing generated data and delets the cache."
task :cleanup do
  
  FileUtils.rm_r 'out' if File.exists? 'out'
  FileUtils.rm 'webgen.cache' if File.exists? 'webgen.cache'
end

namespace :generate do

  desc "Generate thumbnails for gallery pictures"
  task :thumbnails do
    files = FileList.new('out/cars/**/*.jpg') do |fl|
      fl.include("*.jpg", "*.jpeg", "*.png", "*.gif")
    end
    files.add FileList.new('out/drivers/**/*.jpg') do |fl|
      fl.include("*.jpg", "*.jpeg", "*.png", "*.gif")
    end
    files.add FileList.new('out/news/**/*.jpg') do |fl|
      fl.include("*.jpg", "*.jpeg", "*.png", "*.gif")
    end
    puts files
    create_thumbnails files
  end
  
  def create_thumbnails(sourceFileList)
  
    widthx = 200          # default width of generated image
    heightx = 200         # default height of generated image
    
    sourceFileList.each do |srcFile|
      puts "Generate thumbnail of #{srcFile}"
      unless File.directory? srcFile
        filepath = srcFile    # Path to file
        
        format = srcFile.split(".").last   # Format - extension
        filename = srcFile.split(".").first # just file name without extension
    
        img = Magick::Image::read(srcFile).first
       
        thumb = img.resize_to_fit(widthx, heightx)
        thumb.write filename + "_thumbnail." + format  
      end
    end
  end  

end
