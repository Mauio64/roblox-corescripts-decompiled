local Parent = script:FindFirstAncestor("AppChatNetworking").Parent

return `https://apis.{ require(Parent.Http).Url.DOMAIN }platform-chat-api`
