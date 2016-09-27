class YandexError < RuntimeError
  def initialize(mes,code)
    super(mes)
    @code = code
  end

  def code
    @code
  end
end

class YandexTranslator
    require 'net/http'
    require 'openssl'
    require 'json'

    class Connection
      def initialize(key)
        @key = key
        @http = Net::HTTP.new('translate.yandex.net', 443)
        @http.use_ssl = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      def request(path, parameters)
        request = Net::HTTP::Post.new("/api/v1.5/tr.json/#{path}")
        request.set_form_data({key:@key}.merge(parameters)) 
        tmp = JSON.parse(@http.request(request).body)
        if (tmp['code'] == nil) || (tmp['code'] == 200)
          tmp
        else
          raise YandexError.new(tmp['message'], tmp['code'])
        end
      end
    end

    def initialize(apikey)
        @con = Connection.new(apikey)     
    end
    
    def translate(text, lang, format = nil, options = nil)
      @con.request('translate', {text:text, lang:lang, format:format, options:options})    
    end

    def detect(text, hint = nil)
      @con.request('detect', {text:text, hint:hint}) 
    end

    def getlangs(uilang)
      @con.request('getLangs', {ui:uilang})        
    end
end
