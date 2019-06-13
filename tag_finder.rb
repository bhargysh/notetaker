require_relative 'file_finder'
require_relative 'notefile'
class TagFinder
    def initialize(directory)
        @directory = directory
    end

    def find(tag)
        list_of_files = []
        FileFinder.new(@directory).find do |path|
            notefile = Notefile.new(path)
            if notefile.tags.has_key?(tag)
                list_of_files.append(notefile)
            end
        end
        list_of_files
    end
end