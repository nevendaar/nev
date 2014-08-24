# -*- encoding : utf-8 -*-

require 'logger'

class LogFormatter < Logger::Formatter
  FORMAT = "%s, [%s#%d] %s -- %s: %s\n"

  SEVERITY_TO_COLOR_MAP = {
      'DEBUG' => '0;37', 'INFO'  => '32',   'WARN' => '33',
      'ERROR' => '31',   'FATAL' => '1;31', 'ANY'  => '41;37'
  }.freeze

  def initialize
    @datetime_format = '%Y-%m-%d %H:%M:%S.%6N '
  end

  def call(severity, time, progname, msg)
    color = SEVERITY_TO_COLOR_MAP[severity]
    formatted_severity = "\033[#{color}m#{'%5s' % severity.downcase}\033[0m"
    formatted_progname = progname ? "\033[0;36m#{progname}\033[0m" : progname
    FORMAT % [severity[0..0], format_datetime(time), $$, formatted_severity,
              formatted_progname, msg2str(msg)]
  end
end
