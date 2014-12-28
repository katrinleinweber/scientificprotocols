case Rails.env
  when 'development'
    PROTOCOL_FILE_NAME = 'protocol.md'
    GITHUB_AUTH_PATH = '/auth/github'
    GITHUB_AUTH_SCOPES = 'user,repo,gist,write:repo_hook,read:org'
    GITHUB_MAX_PAGE_SIZE = 100
  when 'test'
    PROTOCOL_FILE_NAME = 'protocol.md'
    GITHUB_AUTH_PATH = '/auth/github'
    GITHUB_AUTH_SCOPES = 'user,repo,gist,write:repo_hook,read:org'
    GITHUB_MAX_PAGE_SIZE = 100
  when 'staging'
    PROTOCOL_FILE_NAME = 'protocol.md'
    GITHUB_AUTH_PATH = '/auth/github'
    GITHUB_AUTH_SCOPES = 'user,repo,gist,write:repo_hook,read:org'
    GITHUB_MAX_PAGE_SIZE = 100
  when 'production'
    PROTOCOL_FILE_NAME = 'protocol.md'
    GITHUB_AUTH_PATH = '/auth/github'
    GITHUB_AUTH_SCOPES = 'user,repo,gist,write:repo_hook,read:org'
    GITHUB_MAX_PAGE_SIZE = 100
end