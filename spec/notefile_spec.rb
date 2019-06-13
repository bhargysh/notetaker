require_relative '../notefile'
RSpec.describe(Notefile) do
    let(:path) { File.join(File.dirname(__FILE__), 'fixture_file.txt') }
    subject do
        described_class.new(path)
    end

    context 'when path is given' do
        let(:tags) {
            {
                "SyncOn": "Yes", 
                "Timestamp": "timestamp", 
                "ReadAndWrite": "sure"
            }
        }
        let(:name) { 'fixture_file' }
        it 'returns file tag' do
            expect(subject.tags).to eq(tags)
        end
        it 'returns path' do
            expect(subject.path).to eq(path)
        end
        it 'returns name' do
            expect(subject.name).to eq(name)
        end
    end
end