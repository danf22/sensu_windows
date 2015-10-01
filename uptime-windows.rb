#! /usr/bin/env ruby
#
#   uptime-windows.rb
#
# OUTPUT:
#   metric data
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
#
# LICENSE:
#   Copyright 2015 <piperruno22@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'
require 'socket'
require 'time'

class UptimeMetric < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.system"

  def acquire_uptime
    temp_arr = []
    timestamp = Time.now.utc.to_i
    IO.popen("typeperf -sc 1 \"\\Sistema\\Tiempo de actividad del sistema\" ") { |io| io.each { |line| temp_arr.push(line) } }
    uptime_str = temp_arr[2].split(',')[1]
    uptime = uptime_str.strip[1, uptime_str.length - 3]
    [format('%.2f', uptime), timestamp]
  end

  def run
    # To get the uptime usage
    values = acquire_uptime
    output [config[:scheme], 'uptime'].join('.'), values[0], values[1]
    ok
  end
end
