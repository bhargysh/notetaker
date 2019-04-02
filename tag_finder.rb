class TagFinder
    def initialize(directory)
        @directory = directory
    end

    def find(tag)
        list_of_files = []
        Dir.foreach(@directory) do |filename|
            if File.extname(filename) == '.txt'
                path = File.join(@directory, filename)
                if Notefile.new(path).tags.has_key?(tag)
                    list_of_files.append(File.basename(filename, ".txt"))
                end
            end
        end
        list_of_files
    end
end