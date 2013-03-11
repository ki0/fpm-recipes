class Twemproxy < FPM::Cookery::Recipe
  description 'A fast, light-weight proxy for memcached and redis'

  name     'twemproxy'
  version  '0.2.3'
  revision 0
  homepage 'http://twemproxy.googlecode.com/'
  source   "http://twemproxy.googlecode.com/files/nutcracker-#{version}.tar.gz"
  sha256   '62f8ed47096c8af771ccdca1a7f5814912a588f94472c51f8bdf0fc6bacea23d'

  section       'net'

  def build
    configure :prefix => prefix
    make
  end

  def install
    (etc/'init.d').install_p(workdir/'twemproxy.init.d', 'twemproxy')
    (etc/'twemproxy').install_p(workdir/'yml.root.nutcracker', 'nutcracker.root.yml')
    make :install, 'DESTDIR' => destdir
  end
end
