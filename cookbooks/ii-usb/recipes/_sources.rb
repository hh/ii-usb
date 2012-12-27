['ubuntu-iso','chef-deb'].each do |rf|
  remote_file node['ii-usb'][rf]['src']['cache'] do
    source node['ii-usb'][rf]['src']['url']
    checksum node['ii-usb'][rf]['src']['checksum']
    not_if {File.exists? node['ii-usb'][rf]['src']['cache']}
  end
end
