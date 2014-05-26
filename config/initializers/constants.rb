case Rails.env
  when 'development'
    PROTOCOL_FILE_NAME = 'protocol.md'
  when 'test'
    PROTOCOL_FILE_NAME = 'protocol.md'
  when 'staging'
    PROTOCOL_FILE_NAME = 'protocol.md'
  when 'production'
    PROTOCOL_FILE_NAME = 'protocol.md'
end