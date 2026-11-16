local HttpService = game:GetService("HttpService")

local parent = script.Parent.Parent.Parent
local Url = require(parent.Network.Url)

return function(callback, conversationId, universeId, decorators)
	assert(callback, "requestImpl is required")
	assert(conversationId, "conversationId is required")
	assert(universeId, "universeId is required")

	local jsonEncode = HttpService:JSONEncode({
		conversationId = conversationId,
		universeId = universeId,
		decorators = decorators
	})

	return callback(string.format("%s/send-game-link-message", Url.CHAT_URL), "POST", {
		postBody = jsonEncode
	})
end
