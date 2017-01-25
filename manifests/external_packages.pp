class system::external_packages (
  $config   = undef,
  $sys_schedule = 'always',
) {
  $defaults = {
    ensure   => 'installed',
    schedule => $sys_schedule,
    install_options => []
  }
  if $config {
    create_resources(package, $config, $defaults)
  }
  else {
    $hiera_config = hiera_hash('system::external_packages', undef)
    if $hiera_config {
      create_resources(package, $hiera_config, $defaults)
    }
  }
}
