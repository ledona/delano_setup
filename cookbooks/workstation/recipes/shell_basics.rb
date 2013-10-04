# take care of sprucing up shell stuff
dotfiles_path = File.expand_path(File.dirname(__FILE__)+"../../../..") # a few levels up from this file

# screenrc
link "#{ENV['HOME']}/.screenrc" do
  to "#{dotfiles_path}/dot_screenrc"
  owner "#{ENV['SUDO_USER']}"
end

# tmux
link "#{ENV['HOME']}/.tmux.conf" do
  to "#{dotfiles_path}/dot_tmux.conf"
  owner "#{ENV['SUDO_USER']}"
end

# make sure that my additional shell setup is run
execute "Add dot_bash_profile to .bash_profile" do
  command "echo '
# AUTOMATICALLY ADDED BY DELANO_SETUP
source #{dotfiles_path}/dot_bash_profile' >> '#{ENV['HOME']}/.bash_profile'"
  not_if "grep '#{dotfiles_path}/dot_bash_profile' '#{ENV['HOME']}/.bash_profile'"
end

# slate
link "#{ENV['HOME']}/.slate" do
  to "#{dotfiles_path}/dot_slate"
  owner "#{ENV['SUDO_USER']}"
end

# git 
link "#{ENV['HOME']}/.gitignore" do
  to "#{dotfiles_path}/dot_gitignore"
  owner "#{ENV['SUDO_USER']}"
end

link "#{ENV['HOME']}/.gitconfig" do
  to "#{dotfiles_path}/dot_gitconfig"
  owner "#{ENV['SUDO_USER']}"
end

execute "get git-completion.bash" do
  command "curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash"
  not_if { ::File.exists?("~/.git-completion.bash")}
end

execute "get git-completion.bash" do
  command "curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh"
  not_if { ::File.exists?("~/.git-prompt.sh")}
end
