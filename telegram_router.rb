require_relative 'telegram_responders/photo'
require_relative 'telegram_responders/stats'
require_relative 'telegram_responders/proof'

class TelegramRouter
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def respond!
    (message.photo.any? && photo_response) || text_response
  end

  def photo_response
    if response = TelegramResponder::Photo.new(message).respond!
      BotLogger.info("New Tiemur! #{message.from.username}, #{response}")

      return response
    end

    false
  end

  def text_response
    case message.text
    when '/proof', '/proof@TiemurBot'
      if response = TelegramResponder::Proof.new(message).respond!
        BotLogger.info("Tiemur proofs requested. #{message.from.username}, #{response}")

        return response
      end
    when '/tiemur_stats', '/tiemur_stats@TiemurBot'
      if response = TelegramResponder::Stats.new(message).respond!
        BotLogger.info("Tiemur stats requested. #{message.from.username}, #{response}")

        return response
      end
    end

    false
  end
end
