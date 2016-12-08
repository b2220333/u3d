require "commander"
require "u3d_core"
require "u3d/installer"

HighLine.track_eof = false

module U3d
  class CommandsGenerator
    include Commander::Methods
    UI = U3dCore::UI

    def self.start
      #FastlaneCore::UpdateChecker.start_looking_for_update("gym")
      new.run
    ensure
      #FastlaneCore::UpdateChecker.show_update_status("gym", Gym::VERSION)
    end

    #def convert_options(options)
    #  o = options.__hash__.dup
    #  o.delete(:verbose)
    #  o
    #end

    def split_args(args = ARGV)
      both_args = args.join(" ").split(" -- ")
      args = both_args[0].split(/\s+/)
      extra_args = (both_args[1] || "").split(/\s+/)
      [args, extra_args]
    end

    def run
      # some commands have unknown parameters we just want to pass on
      # split after --
      args, extra_args = split_args()
      Commander::Runner.instance_variable_set :"@singleton", Commander::Runner.new(args)

      program :version, U3d::VERSION
      program :description, U3d::DESCRIPTION
      program :help, "Author", "Jerome Lacoste <jerome@wewanttoknow.com>"
      program :help_formatter, :compact

      global_option("--verbose") { $verbose = true }

      command :run do |c|
        c.syntax = "u3d run"
        c.description = "Run u3d"
        c.action do |_args, options|
          UI.success "Running unity3d #{_args} #{options} #{extra_args}"
        end
      end

      command :installed do |c|
        c.syntax = "u3d installed"
        c.description = "List installed version of Unity3d"
        c.action do |_args, options|
          Commands.list_installed
        end
      end

      default_command :run

      run!
    end
  end
end
