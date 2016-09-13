module Translator
	require 'httpclient'
	@@tr_key = 'trnsl.1.1.20160907T145726Z.184b07fb1c05d3de.bf989596de0117c3f66b2af3204496f9bdf642ee'
	@@tr_lang = 'ru'
	@@tr_client = HTTPClient.new
	def translate(lang_to=@@tr_lang) 
		url = "https://translate.yandex.net/api/v1.5/tr/translate?key=#{@@tr_key}&lang=#{lang_to}&options=1&text=#{self.to_s}"
		text = @@tr_client.get( url ).body
		text =~ /(?<=<text>).*(?=<\/text>)/
		$~.to_s
	end
end
class String
	include Translator
end
puts gets.translate()