require 'git'
require_relative 'file_finder'
class GitSync
    def initialize(directory)
        @directory = directory
    end

    def sync(paths)
        git = Git.open(@directory)
        paths.each { |path| git.add(path) }
        new_tree_id = git.write_tree
        if new_tree_id != tree_sha(git)
            git.commit('Sync')
            current_branch = git.current_branch
            remote = git.config["branch.#{current_branch}.remote"]
            merge = git.config["branch.#{current_branch}.merge"]
            git.push(remote, "#{current_branch}:#{merge}") if remote && merge
        end
    end

    private
    def tree_sha(git)
        head = git.branch
        return nil unless head.current
        head.gcommit.gtree.sha
    end
end