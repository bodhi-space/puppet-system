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
  ) {
    if $ensure == 'removed' {
      exec {"remove $title":
        command => "/usr/bin/yum -y -q remove $title",
        before => Package["$title"],
        require => $require,
        onlyif => "/bin/rpm --quiet -q $title",
      }
      package {"$title":
        ensure => absent,
        before => $before,
        notify => $notify,
      }
    } else {
      package {"$title":
        ensure => $ensure,
        before => $before,
        require => $require,
        notify => $notify,
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
