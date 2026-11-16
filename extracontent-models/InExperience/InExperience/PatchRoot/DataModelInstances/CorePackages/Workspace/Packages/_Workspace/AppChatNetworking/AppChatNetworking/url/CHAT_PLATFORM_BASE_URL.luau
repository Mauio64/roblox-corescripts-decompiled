local parent = script:FindFirstAncestor("AppChatNetworking").Parent
local Http = require(parent.Http)
return `https://apis.{Http.Url.DOMAIN}platform-chat-api`
