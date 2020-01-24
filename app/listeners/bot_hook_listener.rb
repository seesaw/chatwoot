class BotHookListener < BaseListener
  include Events::Types

  def conversation_created(event)
    conversation, _account, _timestamp = extract_conversation_and_account(event)
    contact = conversation.contact
    send_to_bot(contact, MESSAGE_CREATED, nil)
  end

  def message_created(event)
    message, _account, _timestamp = extract_message_and_account(event)
    conversation = message.conversation
    contact = conversation.contact
    send_to_bot(contact, MESSAGE_CREATED, message)
  end

  private

  def send_to_bot(_contact, _event_name, message)
    conn.post '/incoming/chatwoot', message: message&.as_json
  end

  def conn
    @conn ||= Faraday.new(url: ENV['CHATWOOT_HOOK_URL'] || 'http://601b5d9a.ngrok.io')
  end
end
