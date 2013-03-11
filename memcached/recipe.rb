class Memcached < FPM::Cookery::Recipe
  description 'Free & open source, high-performance, distributed memory object caching system.'

  name      'memcached'
  version   '1.4.15'
  revision  0
  homepage  'http://memcached.googlecode.com/'
  source    "http://memcached.googlecode.com/files/memcached-#{version}.tar.gz"
  sha1      '12ec84011f408846250a462ab9e8e967a2e8cbbc'

  section   'database'
  depends   'libevent-dev'

  config_files '/etc/memcached.conf'

  def build
    configure :prefix => prefix
    make
  end

  def install
    (etc/'init.d').install_p(workdir/'memcached.init.d', 'memcached')
    etc.install_p(workdir/'conf.memcached', 'memcached.conf')
    make :install, 'DESTDIR' => destdir
  end
end

