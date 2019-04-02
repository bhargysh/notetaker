require 'clamp'

class Notefile
    attr_reader :tags
    def initialize(filename)
        tags = IO.readlines(filename).take_while { |line|
            line.chomp!
            !line.empty?
        }.map { |tag| 
            element = tag.split(': ', 2)
            if element.length == 2
                element[0] = element[0].to_sym
                element
            else
                nil
            end
        }.compact
        @tags = Hash[tags]
    end
end