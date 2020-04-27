require "./toy-lang-tokenizer.cr"
require "./toy-lang-parser.cr"

module Toy::Lang
  VERSION = "0.1.0"

  class CLI
    property arguments : Array(String) = [] of String
    property files : Array(String) = [] of String

    def initialize(@arguments)
      self.parse_arguments
    end

    def self.run(arguments : Array(String))
      cli = self.new(arguments)
      cli.parse_arguments
      cli.run
    end

    def parse_arguments
      idx = 0
      arguments = @arguments
      files = [] of String
      while idx < arguments.size
        opt = arguments[idx]
        case opt
        when "--"
          files << arguments[idx + 1, -1]
          idx = arguments.size
        when "--help", "-h"
          exit show_help
        when %r{^-}
          raise "#{opt}: unknown option"
        else
          files << opt
        end
      end
      @files = files
    end

    def run
      tokenizer = Toy::Lang::Tokenizer.new
      @files.each do |file|
        content = File.read(file)
        result = tokenizer.parse(content)
        puts "#{file}: #{result.inspect}"
      end
    end
  end
end
