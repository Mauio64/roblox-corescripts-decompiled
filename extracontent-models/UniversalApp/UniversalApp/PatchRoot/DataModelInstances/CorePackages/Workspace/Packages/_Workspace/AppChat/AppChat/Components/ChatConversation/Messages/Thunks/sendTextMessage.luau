local AppChat = script:FindFirstAncestor("AppChat")
local SendTextMessage = require(AppChat.Conversations.Thunks.SendTextMessage)
local v3 = require(AppChat.Logger):new(script.Name)

return function(...) -- line: 5
	-- upvalues: v3 (copy), SendTextMessage (copy)
	v3:info("Sending text message")

	return SendTextMessage(...)
end
