class Nginx < FPM::Cookery::Recipe
  description 'a high performance web server and a reverse proxy server'

  name     'nginx'
  version  '1.3.9'
  revision 1
  homepage 'http://nginx.org/'
  source   "http://nginx.org/download/nginx-#{version}.tar.gz"
  sha256   '30463a867614bed304f6c02f6a35ff697ec70c227d87af0772a417ee05f548df'

  section 'httpd'

  build_depends 'libpcre3-dev', 'zlib1g-dev', 'libssl-dev', 'libldap2-dev'
  depends       'libpcre3', 'zlib1g', 'libssl1.0.0'

  provides  'nginx-full', 'nginx-common'
  replaces  'nginx-full', 'nginx-common'
  conflicts 'nginx-full', 'nginx-common'

  config_files '/etc/nginx/nginx.conf', '/etc/nginx/mime.types',
               '/var/www/nginx-default/index.html'

  def build
    configure \
      '--with-http_stub_status_module',
      '--with-http_ssl_module',
      '--with-http_gzip_static_module',
      '--with-pcre',
      '--with-debug',

      :prefix => prefix,

      :user => 'www-data',
      :group => 'www-data',

      :pid_path => '/var/run/nginx.pid',
      :lock_path => '/var/lock/nginx.lock',
      :conf_path => '/etc/nginx/nginx.conf',
      :http_log_path => '/var/log/nginx/access.log',
      :error_log_path => '/var/log/nginx/error.log',
      :http_proxy_temp_path => '/var/lib/nginx/proxy',
      :http_fastcgi_temp_path => '/var/lib/nginx/fastcgi',
      :http_client_body_temp_path => '/var/lib/nginx/body',
      :http_uwsgi_temp_path => '/var/lib/nginx/uwsgi',
      :http_scgi_temp_path => '/var/lib/nginx/scgi'

    make
  end

  def install
    # startup script
    (etc/'init.d').install_p(workdir/'nginx.init.d', 'nginx')

    # config files
    (etc/'nginx').install Dir['conf/scgi_params']
    (etc/'nginx').install Dir['conf/uwsgi_params']
    (etc/'nginx').install Dir['conf/fastcgi_params']
    (etc/'nginx').install Dir['conf/koi-utf']
    (etc/'nginx').install Dir['conf/koi-win']
    (etc/'nginx').install Dir['conf/win-utf']
    (etc/'nginx').install Dir['conf/mime.types']

    # my nginx.conf
    (etc/'nginx').install_p(workdir/'conf.nginx', 'nginx.conf')

    # sites dir
    %w( conf.d sites-available sites-enabled ).map do |dir|
      (etc/'nginx'/dir).mkpath
    end
    (etc/'nginx'/'conf.d').install  Dir['conf/fastcgi.conf']
    (etc/'nginx'/'sites-available').install_p(workdir/'vhost.default', 'default')

    # default site
    (var/'www/nginx-default').install Dir['html/*']

    # server
    sbin.install Dir['objs/nginx']

    # man page
    man8.install Dir['objs/nginx.8']
    system 'gzip', man8/'nginx.8'

    # support dirs
    %w( run lock log/nginx lib/nginx ).map do |dir|
      (var/dir).mkpath
    end
  end
end
