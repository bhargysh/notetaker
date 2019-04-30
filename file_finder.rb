class FileFinder
    def initialize(directory)
        @directory = directory
    end

    def find
        Dir.foreach(@directory) do |filename|
            if File.extname(filename) == '.txt'
                yield File.join(@directory, filename)
            end
        end
    end
end