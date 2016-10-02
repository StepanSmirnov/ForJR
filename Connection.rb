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