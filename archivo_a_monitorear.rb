#! /usr/bin/env ruby
#
#   metrics-windows-disk-usage.rb
#
# DESCRIPTION:
#   This plugin collects disk capacity metrics.
#   Created to return values in same format as system/disk-usage-metric
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   Copyright 2014 <alex.slynko@wonga.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'socket'

#
# Disk Usage Metric
#
class DiskUsageMetric < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.archivo_a_monitorear"

  option :ignore_mnt,
         description: 'Ignore mounts matching pattern(s)',
         short: '-i MNT[,MNT]',
         long: '--ignore-mount',
         proc: proc { |a| a.split(',') }

  option :include_mnt,
         description: 'Include only mounts matching pattern(s)',
         short: '-I MNT[,MNT]',
         long: '--include-mount',
         proc: proc { |a| a.split(',') }


  def run
    `c:\\opt\\sensu\\plugins\\archivo_a_monitorear.cmd`.split(/\n+/).each do |line|
       fileName, fileSize = line.split
      next if config[:ignore_mnt] && config[:ignore_mnt].find { |x| mnt.match(x) }
      next if config[:include_mnt] && !config[:include_mnt].find { |x| mnt.match(x) }

      fileName = fileName
      fileSize= fileSize
      output [config[:scheme], fileName].join('.'),(fileSize)
    end
    ok
  end
end
