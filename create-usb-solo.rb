current_dir = ::File.dirname(::File.absolute_path(__FILE__))
cookbook_path "#{current_dir}/cookbooks", "#{current_dir}/site-cookbooks"

solo_json_file = "#{current_dir}/.chef/create-usb-solo.json"
open(solo_json_file,'w+') do |f|
  f.write(
    {
      "run_list" => [
        "recipe[ii-usb::create-usb-solo]"
        ],
      'ii-usb' => {
        'target-device' => ENV['TARGETUSB']
      }
    }.to_json
    )
end
json_attribs solo_json_file

cache_type               'BasicFile'
cache_options( :path => "#{current_dir}/.chef/checksums")
file_cache_path "#{current_dir}/../cache"
file_backup_path "#{current_dir}/.chef/backup"
role_path "#{current_dir}/roles"
verbose_logging false
