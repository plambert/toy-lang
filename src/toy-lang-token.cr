module Toy::Lang
  class Token
    enum TokenType
      WHITESPACE
      HorizontalWhiteSpace # /[ \t]+/
      NewLine              # /\n/
      WhiteSpace           # /\s+/
      WHITESPACE_END

      SYMBOL
      Equals           # /=/
      LessThan         # /</
      GreaterThan      # />/
      Asterix          # /\*/
      Comma            # /,/
      Percent          # /%/
      DollarSign       # /\$/
      AtSign           # /\@/
      ExclamationPoint # /!/
      Tilde            # /~/
      Caret            # /^/
      Ampersand        # /&/
      Hyphen           # /-/
      Underscore       # /_/
      PlusSign         # /\+/
      Period           # /\./
      Colon            # /:/
      Semicolon        # /;/
      Backslash        # /\\/
      Pipe             # /\|/
      SYMBOL_END

      DELIMITER
      SIMPLE_DELIMITER
      DoubleQuote # /"/ # begins StringDoubleQuote
      SingleQuote # /'/ # begins StringSingleQuote
      BackQuote   # /`/
      SIMPLE_DELIMITER_END

      BALANCED_DELIMITER
      ParenOpen    # /\(/
      ParenClose   # /\)/
      BracketOpen  # /\[/
      BracketClose # /\]/
      BraceOpen    # /\{/
      BraceClose   # /\}/
      BALANCED_DELIMITER_END
      DELIMITER_END

      COMPLEX_TOKEN
      IDENTIFIER
      IdentifierLower # /[a-z][a-zA-Z0-9_]*/
      IdentifierUpper # /[A-Z][a-zA-Z0-9_]*/
      IDENTIFIER_END

      NUMERIC
      Real    # /\.\d+[_\d]*|[_\d]*\d+\.[_\d]*/
      Integer # /[_\d]*\d[_\d]*/ # after Real
      NUMERIC_END

      Comment            # /\#.*\n/
      InterpolationOpen  # /\#\{/    # complex
      InterpolationClose # /\}/      # complex
      FunctionOpen       # /\{\s*\(/ # complex
      FunctionClose      # /\}/      # complex
      MethodCall         # /\./      # complex
      COMPLEX_TOKEN_END

      def is_complex?
        self > COMPLEX_TOKEN && self < COMPLEX_TOKEN_END
      end

      def is_whitespace?
        self > WHITESPACE && self < WHITESPACE_END
      end

      def is_delimiter?
        self > DELIMITER && self < DELIMITER_END
      end

      def is_simple_delimiter?
        self > SIMPLE_DELIMITER && self < SIMPLE_DELIMITER_END
      end

      def is_balanced_delimiter?
        self > BALANCED_DELIMITER && self < BALANCED_DELIMITER_END
      end

      def is_opening_delimiter?
        if !self.is_delimiter?
          false
        elsif self.is_simple_delimiter?
          true
        elsif 1 == (self.value - BALANCED_DELIMITER.value) % 0
          true
        else
          false
        end
      end

      def closing_delimiter? : TokenType?
        if self.is_opening_delimiter?
          TokenType.new(self.value + 1)
        else
          nil
        end
      end

      def closing_delimiter : TokenType
        raise "not a balanced delimiter" unless self.is_balanced_delimiter?
        raise "not an opening delimiter" unless self.is_opening_delimiter?
        self.closing_delimiter? || raise "no closing delimiter"
      end
    end
    property tokentype : TokenType
    property start : UInt32
    property length : UInt32

    def initialize(@start, @length, @tokentype)
    end

    def initialize(text : String, offset : Int32 = 0)
      if regex = self.regex
        if match = text.match regex: regex, pos: offset
        end
      end
    end

    def regex
      # generated with tools/token-def-regex
      case self
      when HorizontalWhiteSpace then %r{[ \t]+}
      when NewLine              then %r{\n}
      when WhiteSpace           then %r{\s+}
      when Equals               then %r{=}
      when LessThan             then %r{<}
      when GreaterThan          then %r{>}
      when Asterix              then %r{\*}
      when Comma                then %r{,}
      when Percent              then %r{%}
      when DollarSign           then %r{\$}
      when AtSign               then %r{\@}
      when ExclamationPoint     then %r{!}
      when Tilde                then %r{~}
      when Caret                then %r{^}
      when Ampersand            then %r{&}
      when Hyphen               then %r{-}
      when Underscore           then %r{_}
      when PlusSign             then %r{\+}
      when Period               then %r{\.}
      when Colon                then %r{:}
      when Semicolon            then %r{;}
      when Backslash            then %r{\\}
      when Pipe                 then %r{\|}
      when DoubleQuote          then %r{"}
      when SingleQuote          then %r{'}
      when BackQuote            then %r{`}
      when ParenOpen            then %r{\(}
      when ParenClose           then %r{\)}
      when BracketOpen          then %r{\[}
      when BracketClose         then %r{\]}
      when BraceOpen            then %r{\{}
      when BraceClose           then %r{\}}
      when IdentifierLower      then %r{[a-z][a-zA-Z0-9_]*}
      when IdentifierUpper      then %r{[A-Z][a-zA-Z0-9_]*}
      when Real                 then %r{\.\d+[_\d]*|[_\d]*\d+\.[_\d]*}
      when Integer              then %r{[_\d]*\d[_\d]*}
      when Comment              then %r{\#.*\n}
      when InterpolationOpen    then %r{\#\{}
      when InterpolationClose   then %r{\}}
      when FunctionOpen         then %r{\{\s*\(}
      when FunctionClose        then %r{\}}
      when MethodCall           then %r{\.}
      else
        raise "no regex for #{self.inspect}"
      end
    end
  end
end

# # example toy-lang script

# double = { (n) n * 2 }

# Process.argv.each { (a)
#   puts "#{a}: #{double a}"
# }
