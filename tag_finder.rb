class TagFinder
    def initialize(directory)
        @directory = directory
    end

    def find(tag)
        list_of_files = []
        FileFinder.new(@directory).find do |path|
            if Notefile.new(path).tags.has_key?(tag)
                list_of_files.append(File.basename(path, ".txt"))
            end
        end
        list_of_files
    end
end