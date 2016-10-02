class YandexError < RuntimeError
  def initialize(mes,code)
    super(mes)
    @code = code
  end

  def code
    @code
  end
end
