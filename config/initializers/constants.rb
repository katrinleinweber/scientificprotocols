case Rails.env
  when 'development'
    PROTOCOL_FILE_NAME = 'protocol.md'
    GITHUB_AUTH_PATH = '/auth/github'
    GITHUB_AUTH_SCOPES = 'user:email,gist'
    GITHUB_MAX_PAGE_SIZE = 100
    WORD_MIME_TYPES = [
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/msword'
    ]
    WORD_FILE_EXTENSIONS = ['.doc', '.docx']
  when 'test'
    PROTOCOL_FILE_NAME = 'protocol.md'
    GITHUB_AUTH_PATH = '/auth/github'
    GITHUB_AUTH_SCOPES = 'user:email,gist'
    GITHUB_MAX_PAGE_SIZE = 100
    WORD_MIME_TYPES = [
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/msword'
    ]
    WORD_FILE_EXTENSIONS = ['.doc', '.docx']
  when 'staging'
    PROTOCOL_FILE_NAME = 'protocol.md'
    GITHUB_AUTH_PATH = '/auth/github'
    GITHUB_AUTH_SCOPES = 'user:email,gist'
    GITHUB_MAX_PAGE_SIZE = 100
    WORD_MIME_TYPES = [
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/msword'
    ]
    WORD_FILE_EXTENSIONS = ['.doc', '.docx']
  when 'production'
    PROTOCOL_FILE_NAME = 'protocol.md'
    GITHUB_AUTH_PATH = '/auth/github'
    GITHUB_AUTH_SCOPES = 'user:email,gist'
    GITHUB_MAX_PAGE_SIZE = 100
    WORD_MIME_TYPES = [
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/msword'
    ]
    WORD_FILE_EXTENSIONS = ['.doc', '.docx']
end
