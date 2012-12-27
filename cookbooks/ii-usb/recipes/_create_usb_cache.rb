directory "#{node['ii-usb']['target-mountpoint']}/cache"

['ubuntu-iso','chef-deb'].each do |cf|
  target_file = File.join(node['ii-usb']['target-mountpoint'],'cache',
    File.basename(node['ii-usb'][cf]['src']['cache']))
  file target_file do
    content node['ii-usb'][cf]['src']['cache']
    provider Chef::Provider::File::Copy
    not_if {File.size(target_file) > 10 * 1000 * 1000 }# at least 10 meg... speeds things up
  end
end
