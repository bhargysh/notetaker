require 'clamp'

class Notefile
    attr_reader :tags, :path, :name
    def initialize(path)
        tags = IO.readlines(path).take_while { |line|
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
        @path = path
        @name = File.basename(path, ".txt")
    end
end