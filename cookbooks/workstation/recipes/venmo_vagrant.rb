dotfiles_path = File.expand_path(File.dirname(__FILE__)+"../../../..") # a few levels up from this file

# make sure that my additional shell setup is run
execute "Add dot_bash_profile to .bash_profile" do
  command "echo '
source #{dotfiles_path}/dot_bash_venmo_vagrant.sh' >> '#{ENV['HOME']}/.bash_profile'"
  not_if "grep '#{dotfiles_path}/dot_bash_venmo_vagrant_profile' '#{ENV['HOME']}/.bash_profile'"
end
