require_relative '../tag_finder'
RSpec.describe(TagFinder) do
    let(:directory) { File.dirname(__FILE__) }
    subject { described_class.new(directory) }

    context 'when tag is searched for' do
        let(:tag) { :ReadAndWrite }
        let(:list_of_files) { ['fixture_file'] }
        it 'returns a list of filenames' do
            expect(subject.find(tag)).to eq(list_of_files)
        end
    end
end