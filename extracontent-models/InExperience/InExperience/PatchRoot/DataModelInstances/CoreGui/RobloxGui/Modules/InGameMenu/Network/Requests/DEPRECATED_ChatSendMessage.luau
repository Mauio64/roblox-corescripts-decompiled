local HttpService = game:GetService("HttpService")

local parent = script.Parent.Parent.Parent
local Url = require(parent.Network.Url)

return function(callback, conversationId, message, decorators)
	local jsonEncode = HttpService:JSONEncode({
		conversationId = conversationId,
		message = message,
		decorators = decorators
	})

	return callback(string.format("%s/send-message", Url.CHAT_URL), "POST", {
		postBody = jsonEncode
	})
end
