require_relative '../file_finder'
RSpec.describe(FileFinder) do

    let(:directory) { File.dirname(__FILE__) }
    subject { described_class.new(directory) }

    describe 'find' do
        let(:list_of_files) do
            [
            File.join(directory,'fixture_file.txt'),
            File.join(directory,'file.txt'),
            File.join(directory,'another_file.txt')
            ]
        end
        it 'yields a list of filenames' do
            files = []
            subject.find do |file|
                files << file
            end
            expect(files).to match_array(list_of_files)
        end
    end

end