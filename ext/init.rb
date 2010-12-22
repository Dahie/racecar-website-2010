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

def gallery_image target_file, options=nil
  format = target_file.split(".").last   # Format - extension
  filename = target_file.split(".").first # just file name without extension
  thumbnail_file = filename + "_thumbnail." + format
  
  html = "<a href=\"#{target_file}\""
  if options
    html += " rel=\"#{options[:rel]}\"" if options[:rel]
    html += " style=\"#{options[:style]}\"" if options[:style]
    html += " class=\"#{options[:class]}\"" if options[:class]
    html += " title=\"#{options[:title]}\"" if options[:title]
    html += " id=\"#{options[:id]}\"" if options[:id]
  end
  html += ">#{image_tag(thumbnail_file)}</a>"
  html
end

def image_tag src, options=nil
  html = "<img src=\"#{src}\" "
  if options
    html += "alt=\"#{options[:alt]}\" " if options[:alt]
    html += "class=\"#{options[:class]}\" " if options[:class]
    html += "id=\"#{options[:id]}\" " if options[:id]
  end
  html += "\>"
  html
end