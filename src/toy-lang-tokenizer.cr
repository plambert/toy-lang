require "./toy-lang-token.cr"

class Toy::Lang::Tokenizer
  property tokens : Array(Toy::Lang::Token) = [] of Toy::Lang::Token

  def initialize
  end
end
