require 'pathname'
require 'fileutils'
require 'optparse'
require 'ostruct'

class ArgumentParser
  VALID_OPERATIONS = %w(copy_to_system copy_to_repo)

  def initialize
    @options           = OpenStruct.new
    @options.operation = nil

    @option_parser = OptionParser.new {|opts|
      opts.on("-o", "--operation=OPERATION", "(#{VALID_OPERATIONS.join(', ')})") {|operation|
        @options.operation = operation
      }

      opts.on_tail("-h", "--help", "show this message") do
        puts opts
        exit
      end
    }
  end

  def parse(args)
    @option_parser.parse!(args)

    validate
    @options
  end

  private

  def validate
    if @options.operation.nil?
      log_error("no operation has been chosen. please set with --operation.")
      puts @option_parser.help
      exit 1
    elsif !VALID_OPERATIONS.include?(@options.operation)
      log_error("'#{@options.operation}' is not a valid operation")
      puts @option_parser.help
      exit 1
    end 
  end

  def log_error(msg)
    puts "[\033[0;31mERROR\033[0;0m] - #{msg}"
  end
end

class DotFilesHelper
  def initialize(options)
    @options        = options
    @home_directory = Pathname.new("/home/#{`whoami`}".strip)

    repo_directory_string = __FILE__.sub(/scripts\/dotfiles\.rb$/, '')
    repo_directory_string = (if repo_directory_string.empty?
      './'
    elsif repo_directory_string.start_with?('/')
      repo_directory_string
    elsif repo_directory_string.start_with?('.')
      repo_directory_string
    else
      "./#{repo_directory_string}"
    end)

    @repo_directory = Pathname.new(repo_directory_string)
  end

  def run
    send(@options.operation)
  end

  private

  def copy_to_repo
    File.open(@home_directory.join('.dotfiles_manifest')) {|f|
      f.each_line {|line|
        pathname                = Pathname.new(line.strip)
        entry_to_copy           = @home_directory.join(pathname)
        dir_to_ensure_existence = @repo_directory


        unless pathname.dirname.to_s == '.'
          dir_to_ensure_existence = dir_to_ensure_existence.join(pathname.dirname)

          unless dir_to_ensure_existence.exist?
            self.log_info("creating directory #{dir_to_ensure_existence}")
            FileUtils.mkdir_p(dir_to_ensure_existence)
          end
        end


        if entry_to_copy.directory?
          self.log_info("cp -R #{entry_to_copy} #{dir_to_ensure_existence}")
          FileUtils.cp_r(entry_to_copy, dir_to_ensure_existence)
        elsif entry_to_copy.file?
          self.log_info("cp #{entry_to_copy} #{dir_to_ensure_existence}")
          FileUtils.cp(entry_to_copy, dir_to_ensure_existence)
        end
      }
    }
  end

  def copy_to_system
  end

  def log_info(msg)
    puts "[\033[0;32mINFO\033[0;0m] - #{msg}"
  end
end

options = ArgumentParser.new.parse(ARGV)
DotFilesHelper.new(options).run
