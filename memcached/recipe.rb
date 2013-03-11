class Memcached < FPM::Cookery::Recipe
  description 'Free & open source, high-performance, distributed memory object caching system.'

  name      'memcached'
  version   '1.4.15'
  revision  0
  homepage  'http://memcached.googlecode.com/'
  source    "http://memcached.googlecode.com/files/memcached-#{version}.tar.gz"
  sha1      '12ec84011f408846250a462ab9e8e967a2e8cbbc'

  section   'database'
  build_depends   'libevent-dev'
  depends   'libevent-core-1.4-2'
  config_files '/etc/memcached.conf'

  def build
    configure :prefix => prefix
    make
  end

  def install
    (etc/'init.d').install_p(workdir/'memcached.init.d', 'memcached')
    etc.install_p(workdir/'conf.memcached', 'memcached.conf')
    %w( memcached memcached/scripts).map do |dir|
      (share/dir).mkpath
    end
    (share'/memcached/scripts').install_p(workdir/'conf.memcached-start', 'memcached-start')
    (share'/memcached/scripts').install_p(workdir/'conf.memcached-tool', 'memcached-tool')
    make :install, 'DESTDIR' => destdir
  end
end

