require_relative '../git_sync'
require 'tmpdir'
require 'git'

RSpec.describe(GitSync) do
    subject { described_class.new(local_dir) }
    attr_reader :local_dir, :remote_dir, :local_repo, :remote_repo
    context 'when we have a remote repo' do
        around do |test|
            Dir.mktmpdir("git_sync") do |dir|
                @local_dir = File.join(dir, 'local')
                @remote_dir = File.join(dir, 'remote')
                @remote_repo = Git.init(@remote_dir)
                File.write(
                    File.join(@remote_dir, 'test_file.txt'),
                    File.read(File.join(File.dirname(__FILE__), 'fixture_file.txt'))
                )
                @remote_repo.add('test_file.txt')
                @remote_repo.commit('Fixture')
                @remote_repo.config('receive.denyCurrentBranch','ignore')
                @local_repo = Git.clone(@remote_dir, @local_dir)

                test.run
            end

        end
        context 'when a file is modified' do
            let!(:old_commit_id) { remote_repo.branch.gcommit.sha }
            let(:paths) { File.join(@local_dir, 'test_file.txt') }
            #TODO: handle only files that have a sync tag to be `git synced`
            before do
                File.write(File.join(@local_dir, 'test_file.txt'), 'add more stuff', mode:'a')
            end
            it 'syncs the file onto git' do
                subject.sync(paths)
                new_commit_id = local_repo.branch.gcommit.sha
                expect(new_commit_id).not_to eq(old_commit_id)
            end
        end

        context 'when more than one file is modified' do
            let!(:old_commit_id) { remote_repo.branch.gcommit.sha }
            let(:paths) { [File.join(@local_dir, 'new_file.txt'), File.join(@local_dir, 'test_file.txt')] }
            before do
                File.write(File.join(@local_dir, 'new_file.txt'), 'hello new file')
                File.write(File.join(@local_dir, 'test_file.txt'), 'yay more content in this file', mode: 'a')
            end
            it 'creates one new commit' do
                subject.sync(paths)
                new_commit = local_repo.log(1).first
                expect(new_commit.parent.sha).to eq(old_commit_id)
            end
            it 'pushes the new commit to remote' do
                subject.sync(paths)
                new_remote_commit_id = remote_repo.branch.gcommit.sha
                new_local_commit_id = local_repo.branch.gcommit.sha
                expect(new_remote_commit_id).to eq(new_local_commit_id)
            end
        end

        context 'when no files are modified' do
            let(:old_commit_id) { remote_repo.branch.gcommit.sha }
            let(:paths) { File.join(@local_dir, 'test_file.txt') }
            it 'does not create a commit' do
                subject.sync(paths)
                new_commit_id = local_repo.branch.gcommit.sha
                expect(new_commit_id).to eq(old_commit_id)
            end
        end
    end
    context 'when it is a new repository with no remote' do
        around do |test|
            Dir.mktmpdir("git_sync") do |dir|
                @local_dir = File.join(dir, 'local')
                @local_repo = Git.init(@local_dir)
                test.run
            end
        end
        before do
            File.write(File.join(@local_dir, 'test_file.txt'), 'add more stuff', mode:'a')
        end
        let(:paths) { File.join(@local_dir, 'test_file.txt') }
        it 'creates a commit with no parents' do
            subject.sync(paths)
            commit = local_repo.branch.gcommit
            expect(commit.parents).to be_empty
        end
    end
end