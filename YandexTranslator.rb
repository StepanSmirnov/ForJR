class YandexTranslator
	require 'net/http'
	require 'uri'
	require "openssl"
	def initialize(apikey)
		@key=apikey		
		@http = Net::HTTP.new('translate.yandex.net', 443)
		@http.use_ssl = true
 		@http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	end
	def translate(text,lang,format=nil,options=nil)#,format,options
		request = Net::HTTP::Post.new('/api/v1.5/tr/translate')
		request.set_form_data({key:@key,text:text,lang:lang,format:format,options:options}) 
		@http.request(request).body[/(?<=text>).*(?=<\/text)/]
	end
	def detect(text,hint=nil)#,hint
		request = Net::HTTP::Post.new('/api/v1.5/tr/detect')
		request.set_form_data({key:@key,text:text,hint:hint}) 
		@http.request(request).body[/(?<=lang=").*(?=")/]
	end
	def getlangs(ui)
		request = Net::HTTP::Post.new('/api/v1.5/tr/getLangs')
		request.set_form_data({key:@key,ui:ui}) 
		@http.request(request).body[/(?<=<Item).*(?=\/><\/langs)/].split('/><Item')	.map{|x| Hash[x[/(?<=key=")\S*(?=")/].to_sym,x[/(?<=value=").*(?=")/]]}	
	end
end
tr=YandexTranslator.new('trnsl.1.1.20160907T145726Z.184b07fb1c05d3de.bf989596de0117c3f66b2af3204496f9bdf642ee')
#puts tr.translate('зажигалка','ru')
puts tr.getlangs('mn')
#puts tr.detect 'fast'