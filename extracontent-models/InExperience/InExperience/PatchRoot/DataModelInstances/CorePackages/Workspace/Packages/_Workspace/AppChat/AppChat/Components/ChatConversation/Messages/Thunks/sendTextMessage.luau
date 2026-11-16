local AppChat = script:FindFirstAncestor("AppChat")
local SendTextMessage = require(AppChat.Conversations.Thunks.SendTextMessage)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

return function(...)
	v:info("Sending text message")
	return SendTextMessage(...)
end
