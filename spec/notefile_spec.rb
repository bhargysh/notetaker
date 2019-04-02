require_relative '../notefile'
RSpec.describe(Notefile) do
    let(:filename) { File.join(File.dirname(__FILE__), 'fixture_file.txt') }
    subject do
        described_class.new(filename)
    end

    context 'when filename is given' do
        let(:tags) {
            {
                "SyncOn": "Yes", 
                "Timestamp": "timestamp", 
                "ReadAndWrite": "sure"
            }
        }
        it 'returns file tag' do
            expect(subject.tags).to eq(tags)
        end
    end
end