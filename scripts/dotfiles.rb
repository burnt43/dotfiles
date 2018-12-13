require 'pathname'
require 'fileutils'

class DotFilesHelper
  def initialize(options={})
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
    File.open(@home_directory.join('.dotfiles_manifest')) {|f|
      f.each_line {|line|
        pathname                = Pathname.new(line.strip)
        entry_to_copy           = @home_directory.join(pathname)
        dir_to_ensure_existence = @repo_directory


        unless pathname.dirname.to_s == '.'
          dir_to_ensure_existence = dir_to_ensure_existence.join(pathname.dirname)

          unless dir_to_ensure_existence.exist?
            self.log_info("creating directory #{dir_to_ensure_existence}")
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

  def log_info(msg)
    puts "[\033[0;32mINFO\033[0;0m] - #{msg}"
  end
end

DotFilesHelper.new.run
