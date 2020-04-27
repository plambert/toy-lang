module Toy::Lang
  class Token
    enum TokenType
      Undefined            # /(?!.)./ # must not ever exist!
      HorizontalWhiteSpace # /[ \t]+/
      NewLine              # /\n/
      WhiteSpace           #
      IdentifierLower      # /[a-z][a-zA-Z0-9_]*/
      IdentifierLower      # /[A-Z][a-zA-Z0-9_]*/
      Real                 # /\.\d+[_\d]*|[_\d]*\d+\.[_\d]*/
      Integer              # /[_\d]*\d[_\d]*/ # after Real
      Equals               # /=/
      BraceOpen            # /\{/
      BraceClose           # /\}/
      LessThan             # /</
      GreaterThan          # />/
      DoubleQuote          # /"/ # begins StringDoubleQuote
      SingleQuote          # /'/ # begins StringSingleQuote
      BackQuote            # /`/
      Comment              # /\#.*\n/
      ParenOpen            # /\(/
      ParenClose           # /\)/
      Period               # /\./
      InterpolationOpen    # /\#\{/    # complex
      InterpolationClose   # /\}/      # complex
      FunctionOpen         # /\{\s*\(/ # complex
    end
    property tokentype : TokenType
    property start : UInt32
    property length : UInt32
  end
end

# # example toy-lang script

# double = { (n) n * 2 }

# Process.argv.each { (a)
#   puts "#{a}: #{double a}"
# }
