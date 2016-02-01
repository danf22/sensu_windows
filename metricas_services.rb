#! /usr/bin/env ruby
#
#   metrics-windows-disk-usage.rb
#
# DESCRIPTION:
#   This plugin collects metrics of services in a list
#   
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
#   Copyright 2016 <piperruno22@gmail.com>
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
         default: "#{Socket.gethostname}.servicios"

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
    `wmic service where started=true get  name,  startname`.split(/\n+/).each do |line|
       fileName, fileSize = line.split
      next if config[:ignore_mnt] && config[:ignore_mnt].find { |x| mnt.match(x) }
      next if config[:include_mnt] && !config[:include_mnt].find { |x| mnt.match(x) }

      fileName = fileName
      fileSize= fileSize
	  fileuno= '1'
      output [config[:scheme], fileName,].join('.'), [fileuno].join(' ') 
    end
    ok
  end
end
