
require 'yaml'

module SenseOfPlace

  class << self

    def get_place
      data = YAML.load(File.read(data_file_path))
      identify_place(data, current_place_information)
    end

    def data_file_path
      if ENV['SENSE_OF_PLACES_YML']
        ENV['SENSE_OF_PLACES_YML']
      else
        "#{ENV['HOME']}/.places.yml"
      end
    end

    def current_place_information

      result                  = { }
      ssid, bssid             = get_airport_info
      gateway_ip, gateway_mac = get_airport_info

      add = -> key, value { result[key] = value unless value.nil? }
      add.call(:ssid, ssid)
      add.call(:bssid, bssid)
      add.call(:gateway_ip, gateway_ip)
      add.call(:gateway_mac, gateway_mac)

      result

    end

    private

    def identify_place(data, current)
      max = data.max_by do |place|
        keys = (place.keys | current.keys) - [:name]
        score = keys.count { |key| !place[key].nil? && !current[key].nil? && place[key] == current[key] }
        score
      end
      max[:name]
    end

    def get_routing_table
      `netstat -nrfinet`.lines.drop(4).map(&:split)
    end

    def get_default_gateway
      table = get_routing_table
      default_gateway_ip  = table.find { |row| row[0] == 'default' }[1]
      default_gateway_mac = table.find { |row| row[0] == default_gateway_ip }[1]
      [default_gateway_ip, default_gateway_mac]
    rescue
      [nil, nil]
    end

    def get_airport_info
      result = `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I`.lines.each_with_object({}) do |line, out|
        if line =~ /(\S[^:]*?): (.*)/
          out[$1] = $2
        end
      end
      [result.fetch("SSID"), result.fetch("BSSID")]
    rescue
      [nil, nil]
    end

  end

end

