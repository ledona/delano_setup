dotfiles_path = File.expand_path(File.dirname(__FILE__)+"../../../..") # a few levels up from this file

# make sure emacs is installed, use macports on osx
package "emacs" do
  action :install
  # only_if "uname -a | grep Darwin"
end
# for emacs use standard package for non osx
# package "emacs" do
#   action :install
#   not_if "uname -a | grep Darwin"
# end

easy_install_package "pyflakes" do
  action :install
  only_if "uname -a | grep Darwin"
end

package "pyflakes" do
  action :install
  not_if "uname -a | grep Darwin"
end

easy_install_package "pep8" do
  action :install
  only_if "uname -a | grep Darwin"
end

package "pep8" do
  action :install
  not_if "uname -a | grep Darwin"
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
%w{multi-web-mode/multi-web-mode.el
   magit/magit-bisect.el magit/magit-key-mode.el magit/magit.el
   pbcopy/pbcopy.el
   popup/popup.el
   flymake/flymake.el
   pycheckers.sh
   fill-column-indicator.el
   flymake-cursor.el
   linum.el
   whitespace.el
   auto-complete/auto-complete-config.el auto-complete/auto-complete.el
}.each do |f_subpath|
  if f_subpath.index('/')
    f_name = f_subpath[f_subpath.rindex('/') + 1 .. -1]
  else
    f_name = f_subpath
  end
  link "#{ENV['HOME']}/.emacs.d/#{f_name}" do
    to "#{dotfiles_path}/emacs/#{f_subpath}"
    owner "#{ENV['SUDO_USER']}"
  end
end
