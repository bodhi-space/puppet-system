class system::packages (
  $config   = undef,
  $sys_schedule = 'always',
) {

  define extended_package (
    $ensure = 'installed',
    $schedule = $sys_schedule,
    $before = [],
    $require = [],
    $notify = [],
    $install_options = [],
    $uninstall_options = [],
    $provider = 'yum',
    $source = undef,
  ) {
    if $ensure =~ /^removed/ {
      if $ensure == 'removed_along_with_all_dependent_packages' {
        exec {"removed $title":
          command => "/usr/bin/yum -y -q remove $title",
          require => $require,
          before => $before,
          notify => $notify,
          onlyif => "/bin/rpm --quiet -q $title",
        }
      } else {
        exec {"removed $title":
          command => "/bin/rpm -e $title",
          require => $require,
          before => $before,
          notify => $notify,
          onlyif => "/bin/rpm --quiet -q $title",
        }
      }
    } else {
      package {"$title":
        ensure => $ensure,
        before => $before,
        require => $require,
        notify => $notify,
        install_options => $install_options,
        uninstall_options => $uninstall_options,
        provider => $provider,
        source => $source,
      }
    }
  }

  $defaults = {
    ensure   => 'installed',
    schedule => $sys_schedule,
  }
  if $config {
    create_resources(package, $config, $defaults)
  } else {
    $hiera_config = hiera_hash('system::packages', {})
    create_resources(extended_package, $hiera_config )
  }
}
