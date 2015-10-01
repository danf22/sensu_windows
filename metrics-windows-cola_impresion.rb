#! /usr/bin/env ruby
#
#   metrics-windows-cola_impresion.rb
#
# DESCRIPTION:
#   Este scripts solo es para windows server en español
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
#   Copyright 2015 <piperruno22@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'socket'

#
# Sql server Database
#
class CpuMetric < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}"

  def cola_impresion
    temp_arr = []
    timestamp = Time.now.utc.to_i
    IO.popen("typeperf -sc 1 \"*(_Total)\\Errores de trabajo\" ") { |io| io.each { |line| temp_arr.push(line) } }
    temp = temp_arr[2].split(',')[1]
    sql_metric = temp[1, temp.length - 3].to_f
    [sql_metric, timestamp]
  end

  def run
    values = cola_impresion
    metrics = {
      cola_impresion_trabajos_err: {
        data: values[0]
      }
    }
    metrics.each do |parent, children|
      children.each do |child, value|
        output [config[:scheme], parent, child].join('.'), value, values[1]
      end
    end
    ok
  end
end
