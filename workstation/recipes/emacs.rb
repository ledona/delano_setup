dotfiles_path = File.expand_path(File.dirname(__FILE__)+"../../..") # a few levels up from this file

# create .emacs.d in home directory
directory "#{ENV['HOME']}/test.emacs.d" do
  action :create
end

# link all emacs dependencies
%w{auto-complete/auto-complete-config.el
   auto-complete/auto-complete.el
   fill-column-indicator.el
   flymake/flymake.el
   magit/magit-bisect.el
   magit/magit-key-mode.el}.each do |f|
  link "#{dotfiles_path}/emacs/#{f}" do
       to "#{ENV['HOME']}/test.emacs.d/#{f}"
    end
end


