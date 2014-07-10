#
# This was copied directly from the existing script which found all the folders
# within that sites-enabled and disabled them. I moved it here but ultimately
# this is some really ugly code that is so complex looking that it makes it
# a terrible thing to maintain in the future.
#
# ISSUE: Ugly
#
directories = Dir["/etc/apache2/sites-enabled/*"].find_all { |name| File.symlink?(name) }

directories.each do |name|

  file name do
    action :delete
    notifies :restart, "service[apache2]"
  end

end

