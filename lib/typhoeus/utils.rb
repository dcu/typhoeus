require 'cgi'

module Typhoeus
  module Utils
    # Taken from Rack::Utils, 1.2.1 to remove Rack dependency.
    def escape(s)
      s.to_s.gsub(/([^ a-zA-Z0-9_.-]+)/u) {
        '%'+$1.unpack('H2'*bytesize($1)).join('%').upcase
      }.tr(' ', '+')
    end
    module_function :escape

    def escape_params(params)
      traverse_params_hash(params)[:params].inject({}) do |memo, (k, v)|
        memo[escape(k)] = CGI.escape(v)
        memo
      end
    end
    module_function :escape_params

    # Params are NOT escaped.
    def traverse_params_hash(hash, result = nil, current_key = nil)
      result = ParamProcessor.traverse_params_hash hash, result, current_key
    end
    module_function :traverse_params_hash

    def traversal_to_param_string(traversal, escape = true)
      traversal[:params].collect { |param|
        escape ? "#{Typhoeus::Utils.escape(param[0])}=#{CGI.escape(param[1])}" : "#{param[0]}=#{param[1]}"
      }.join('&')
    end
    module_function :traversal_to_param_string

    # Return the bytesize of String; uses String#size under Ruby 1.8 and
    # String#bytesize under 1.9.
    if ''.respond_to?(:bytesize)
      def bytesize(string)
        string.bytesize
      end
    else
      def bytesize(string)
        string.size
      end
    end
    module_function :bytesize

    # Return a byteslice from a string; uses String#[] under Ruby 1.8 and
    # String#byteslice under 1.9.
    if ''.respond_to?(:byteslice)
      def byteslice(string, *args)
        string.byteslice(*args)
      end
    else
      def byteslice(string, *args)
        string[*args]
      end
    end
    module_function :byteslice
  end
end
