module Utils
  module Logger
    enum Level
      Debug
      Info
      Warning
      Error
      Critical
    end

    def self.log(level : Level, message : String)
      formatted_message = "[#{level.to_s.upcase}] #{message}"

      # log to STDOUT for debug and info messages
      case level
      when Level::Critical, Level::Error
        STDERR.puts(formatted_message)
      else
        STDOUT.puts(formatted_message)
      end
    end

    # Critical message
    def self.critical(message : String)
      log(Level::Critical, message)
    end

    # Error message
    def self.error(message : String)
      log(Level::Error, message)
    end

    # Warning message
    def self.warning(message : String)
      log(Level::Warning, message)
    end
    
    # Debug message
    def self.debug(message : String)
      log(Level::Debug, message)
    end

    # Info message
    def self.info(message : String)
      log(Level::Info, message)
    end
  end
end
