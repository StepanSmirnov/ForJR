require_relative 'Connection.rb'
require_relative 'YandexError.rb'
class YandexTranslator
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
tr=YandexTranslator.new('trnsl.1.1.20160907T145726Z.184b07fb1c05d3de.bf989596de0117c3f66b2af3204496f9bdf642ee')
puts tr.getlangs('ru')