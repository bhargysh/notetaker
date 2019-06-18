#!/usr/bin/env ruby
require 'clamp'
require_relative 'tag_finder'

Clamp do
    class MainCommand < Clamp::Command
        option ["-d", "--directory"], "DIR", "Working directory", default: "."
    end
    class TagFinderCommand < MainCommand
        parameter "tag", "Name of tag in file" do |tag|
            tag.to_sym
        end
        def execute
            files = TagFinder.new(directory).find(tag)
            puts files.map(&:name)
            exit(1) if files.empty?
        end
    end
    class SyncFinderCommand < MainCommand
        def execute
            files_to_sync = TagFinder.new(directory).find(:SyncOn)
            GitSync.new(directory).sync(files_to_sync.map(&:path))
            puts files_to_sync.map(&:name)
        end
    end
    subcommand "find", "Finds tags within the directory", TagFinderCommand
    subcommand "sync", "Finds files that need to be synced to git", SyncFinderCommand
end

#implement git sync