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
    self.send("#{@options.operation}_pre")

    sync_points = send("#{@options.operation}_sync_points")

    sync_points.each {|_sync_points|
      if _sync_points.source.directory?
        unless _sync_points.destination.exist?
          log_info("creating directory #{_sync_points.destination}")
          FileUtils.mkdir_p(_sync_points.destination)
        end
      else
        unless _sync_points.destination.dirname.exist?
          log_info("creating directory #{_sync_points.destination.dirname}")
          FileUtils.mkdir_p(_sync_points.destination.dirname)
        end
      end

      rsync_string = (if _sync_points.source.directory? && _sync_points.destination.directory?
        %Q(rsync -r #{self.send("#{@options.operation}_rsync_dir_options")} '#{_sync_points.source.to_s}' '#{_sync_points.destination.dirname.to_s}')
      else
        %Q(rsync '#{_sync_points.source.to_s}' '#{_sync_points.destination.to_s}')
      end)
      log_info(rsync_string)
      system(rsync_string)
    }
  end

  private

  SyncPoints = Struct.new(:source, :destination)

  # copy_to_repo
  def copy_to_repo_pre
  end

  def copy_to_repo_sync_points
    result = Array.new

    File.open(@home_directory.join('.dotfiles_manifest')) {|f|
      f.each_line {|line|
        entry_relative_pathname = Pathname.new(line.strip)
        source_for_sync         = @home_directory.join(entry_relative_pathname)
        destination_for_sync    = @repo_directory.join(entry_relative_pathname)

        result.push(SyncPoints.new(source_for_sync, destination_for_sync))
      }
    }

    result
  end

  def copy_to_repo_rsync_dir_options
    '--delete-excluded'
  end

  # copy_to_system
  def copy_to_system_pre
    log_warning("you are about to overwrite your system files. is this okay? (y/n): ", no_newline: true)

    if %w(y Y).include?( (input = gets.chomp) )
      log_info("continuing execution")
    else
      log_info("exiting program")
      exit 1
    end
  end

  def copy_to_system_sync_points
    result = Array.new

    File.open(@repo_directory.join('.dotfiles_manifest')) {|f|
      f.each_line {|line|
        entry_relative_pathname = Pathname.new(line.strip)
        source_for_sync         = @repo_directory.join(entry_relative_pathname)
        destination_for_sync    = @home_directory.join(entry_relative_pathname)

        result.push(SyncPoints.new(source_for_sync, destination_for_sync))
      }
    }

    result
  end

  def copy_to_system_rsync_dir_options
    String.new
  end

  def log_info(msg)
    puts "[\033[0;32mINFO\033[0;0m] - #{msg}"
  end

  def log_warning(msg, options={})
    string = "[\033[0;33mWARNING\033[0;0m] - #{msg}"
    if options[:no_newline]
      print string
    else
      puts string
    end
  end
end

options = ArgumentParser.new.parse(ARGV)
DotFilesHelper.new(options).run
