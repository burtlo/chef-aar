
def user_owns_path?(user,path)
  owner = Mixlib::ShellOut.new("ls -ld #{node['aar']['install_path']} | awk '{ print $3
}' | tr -d '\n'")
  owner.run_command
  owner.stdout.eql? "www-data"
end