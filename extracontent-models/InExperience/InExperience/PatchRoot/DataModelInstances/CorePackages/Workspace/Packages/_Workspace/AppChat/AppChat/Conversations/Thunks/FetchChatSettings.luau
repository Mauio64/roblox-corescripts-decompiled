local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local Url = require(AppChatParent.Http).Url

return RoduxNetworking.GET(script.Name, function(p1) -- line: 7
	-- upvalues: Url (copy)
	return p1(Url.CHAT_URL):path("chat-settings")
end)
