class YandexTranslator
	require 'net/http'
	require "openssl"
	def initialize(apikey)
		@key=apikey		
		@http = Net::HTTP.new('translate.yandex.net', 443)
		@http.use_ssl = true
 		@http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	end
	private def scan(text,pattern)
		if text.index('code="200"')||(text.index('Lang')) 
			text[pattern] 
		else 
			raise ArgumentError,text[/code=.*(?=\/>)/]  
		end		
	end
	def translate(text,lang,format = nil,options = nil)
		request = Net::HTTP::Post.new('/api/v1.5/tr/translate')
		request.set_form_data({key:@key,text:text,lang:lang,format:format,options:options}) 
		scan(@http.request(request).body,/(?<=text>).*(?=<\/text)/)
		end
	def detect(text,hint = nil)
		request = Net::HTTP::Post.new('/api/v1.5/tr/detect')
		request.set_form_data({key:@key,text:text,hint:hint}) 
		scan(@http.request(request).body,/(?<=lang=").*(?=")/)
	end
	def getlangs(uilang)
		request = Net::HTTP::Post.new('/api/v1.5/tr/getLangs')
		request.set_form_data({key:@key,ui:uilang}) 
		if (tmp = scan(@http.request(request).body,/(?<=<Item).*(?=\/><\/langs)/))
			hash=Hash.new()
			tmp.split('/><Item').each{ |x| hash[x[/(?<=key=")\S*(?=")/].to_sym]=x[/(?<=value=").*(?=")/] } 
			hash
		else 
			raise ArgumentError,"Parameter 'ui' is invalid" 
		end
	end
end