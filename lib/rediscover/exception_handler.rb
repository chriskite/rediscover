module Rediscover
  class ExceptionHandler

    def self.set_logger(logger)
      @@logger = logger
    end

    def self.modal(window, exception)
      self.log(exception)
      dlg = Rediscover::Dialog::Error.new(window,
                                          'An error occurred: ' + exception.to_s,
                                          'Error')
      dlg.show_modal
    end

    def self.log(exception)
      @@logger.error(exception)
    end

  end
end
