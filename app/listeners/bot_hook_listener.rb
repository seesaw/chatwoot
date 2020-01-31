class BotHookListener < BaseListener
  include Events::Types

  def message_created(event)
    message, _account, _timestamp = extract_message_and_account(event)
    conversation = message.conversation
    contact = conversation.contact
    send_to_bot(contact, MESSAGE_CREATED, message) if message.incoming?
  end

  private

  def send_to_bot(_contact, _event_name, message)
    message_to_send = add_metadata(to: message)
    conn.post '/incoming/chatwoot', message: message_to_send
  end

  def add_metadata(to:)
    msg = to&.as_json
    msg['verify_token'] = 'verify_token'
    msg
  end

  def conn
    @conn ||= Faraday.new(url: ENV['CHATWOOT_HOOK_URL'] || 'http://localhost:5000')
  end
end
