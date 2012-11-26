# take care of sprucing up shell stuff
dotfiles_path = File.expand_path(File.dirname(__FILE__)+"../../../..") # a few levels up from this file

# screenrc
link "#{ENV['HOME']}/.screenrc" do
  to "#{dotfiles_path}/dot_screenrc"
  owner "#{ENV['SUDO_USER']}"
end

# make sure that my additional shell setup is run
execute "Add dot_bash_profile to .bash_profile" do
  command "echo '
source #{dotfiles_path}/dot_bash_profile' >> '#{ENV['HOME']}/.bash_profile'"
  not_if "grep '#{dotfiles_path}/dot_bash_profile' '#{ENV['HOME']}/.bash_profile'"
end
