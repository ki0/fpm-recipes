class Php < FPM::Cookery::Recipe
  description 'server-side, HTML-embedded scripting language'

  name     'php'
  version  '5.3.10'
  revision 1
  homepage 'http://php.net/'
  source   "http://es.php.net/get/php-#{version}.tar.gz/from/this/mirror"
  md5      '2b3d2d0ff22175685978fb6a5cbcdc13'

  section  'httpd'

  build_depends 'libmcrypt-dev', 'libyaml-dev', 'libcurl4-openssl-dev', 'libxml2-dev', 'libpq-dev', 'libltdl-dev', 'libmysqlclient-dev'
  depends       'autoconf', 'libxml2'

  config_files '/etc/php5/php.ini', '/etc/php5/'

  def build
    configure \
      '--with-gettext',
      '--with-mcrypt',
      '--with-pgsql',
      '--with-mysql',
      '--with-curl',
      '--with-zlib',
      '--with-pdo-pgsql',
      '--enable-calendar',
      '--enable-soap',
      '--enable-mbstring',
      '--enable-bcmath',

      :prefix => '/usr',
      :sysconfdir => '/etc/php5',
      :localstatedir => '/var/php5',
      :mandir => '/usr/share/man',
      :infodir => '/usr/share/doc/'
      make
  end
  def install
    mv 'php.ini-production', 'php.ini'
    (etc/'php5').install Dir['php.ini']
  end
end
