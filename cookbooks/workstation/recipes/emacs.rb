dotfiles_path = File.expand_path(File.dirname(__FILE__)+"../../../..") # a few levels up from this file

# make sure it is installed
package "emacs" do
  action :install
end

package "pyflakes" do
  action :install
end

package "pep8" do
  action :install
end

# link dot emacs
link "#{ENV['HOME']}/.emacs" do
  to "#{dotfiles_path}/emacs/dot_emacs"
  owner "#{ENV['SUDO_USER']}"
end

# create .emacs.d in home directory
directory "#{ENV['HOME']}/.emacs.d" do
  action :create
  owner "#{ENV['SUDO_USER']}"
end

# link all emacs dependencies
%w{auto-complete-config.el auto-complete.el}.each do |f|
  link "#{ENV['HOME']}/.emacs.d/#{f}" do
    to "#{dotfiles_path}/emacs/auto-complete/#{f}"
  end
end

%w{pycheckers.sh fill-column-indicator.el}.each do |f|
  link "#{ENV['HOME']}/.emacs.d/#{f}" do
    to "#{dotfiles_path}/emacs/#{f}"
    owner "#{ENV['SUDO_USER']}"
  end
end

%w{flymake.el}.each do |f|
  link "#{ENV['HOME']}/.emacs.d/#{f}" do
    to "#{dotfiles_path}/emacs/flymake/#{f}"
    owner "#{ENV['SUDO_USER']}"
  end
end

%w{popup.el}.each do |f|
  link "#{ENV['HOME']}/.emacs.d/#{f}" do
    to "#{dotfiles_path}/emacs/popup/#{f}"
    owner "#{ENV['SUDO_USER']}"
  end
end

%w{pbcopy.el}.each do |f|
  link "#{ENV['HOME']}/.emacs.d/#{f}" do
    to "#{dotfiles_path}/emacs/pbcopy/#{f}"
    owner "#{ENV['SUDO_USER']}"
  end
end

%w{magit-bisect.el
   magit-key-mode.el magit.el}.each do |f|
  link "#{ENV['HOME']}/.emacs.d/#{f}" do
    to "#{dotfiles_path}/emacs/magit/#{f}"
    owner "#{ENV['SUDO_USER']}"
  end
end
