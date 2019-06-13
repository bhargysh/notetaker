require_relative '../tag_finder'
RSpec.describe(TagFinder) do
    let(:directory) { File.dirname(__FILE__) }
    subject { described_class.new(directory) }

    context 'when tag is searched for' do
        let(:tag) { :ReadAndWrite }
        let(:list_of_files) { ['fixture_file'] }
        it 'returns a list of names' do
            expect(subject.find(tag).map(&:name)).to eq(list_of_files)
        end
    end
    context 'when tag is not found' do
        let(:tag) { :FunTimes }
        it 'returns empty list' do
            expect(subject.find(tag)).to be_empty 
        end
    end
end