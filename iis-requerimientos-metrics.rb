#! /usr/bin/env ruby
#
#   iis-requerimientos-metrics
#
# DESCRIPTION:
#
# OUTPUT:
#  metric data
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: socket
#
# USAGE:
#
# NOTES:
#  Tested on Windows 2012RC2.
#
# LICENSE:
#   daniel Felipe Morales <piperruno22@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'
require 'socket'

class IisGetRequests < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.iis_get_requests"

  option :site,
         short: '-s sitename',
         default: '_Total'

  def run
    io = IO.popen("typeperf -sc 1 \"Servicio web(#{config[:site]})\\№ de solicitudes Get por segundo\"")
    get_requests = io.readlines[2].split(',')[1].to_f

    output [config[:scheme], config[:site]].join('.'), get_requests
    ok
  end
end
