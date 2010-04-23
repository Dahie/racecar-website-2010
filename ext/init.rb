# = webgen extensions directory
#
# All init.rb files anywhere under this directory get automatically loaded on a webgen run. This
# allows you to add your own extensions to webgen or to modify webgen's core!
#
# If you don't need this feature you can savely delete this file and the directory in which it is!
#
# The +config+ variable below can be used to access the Webgen::Configuration object for the current
# website.
config = Webgen::WebsiteAccess.website.config

def gallery_image target_file, rel = nil
  format = target_file.split(".").last   # Format - extension
  filename = target_file.split(".").first # just file name without extension
  thumbnail_file = filename + "_thumbnail." + format
  
  html = "<a href=\"#{target_file}\""
  html += " rel=\"\"" if rel
  html += ">#{thumbnail_image(thumbnail_file)}</a>"
  html
end

def thumbnail_image file
  "<img src=\"#{file}\" \>"
end
