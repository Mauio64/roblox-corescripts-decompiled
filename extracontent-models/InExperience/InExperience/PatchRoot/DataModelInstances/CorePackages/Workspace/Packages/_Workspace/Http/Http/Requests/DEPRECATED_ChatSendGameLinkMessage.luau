local HttpService = game:GetService("HttpService")

local Http = script:FindFirstAncestor("Http")
local Url = require(Http.Url)
require(Http.RequestTypes)

return function(callback, conversationId, universeId, decorators, isExperienceInvite: boolean?, userId: number?, placeId: number?)
	assert(callback, "requestImpl is required")
	assert(conversationId, "conversationId is required")
	assert(universeId, "universeId is required")

	local jsonEncode = HttpService:JSONEncode({
		conversationId = conversationId,
		universeId = universeId,
		decorators = decorators,
		isExperienceInvite = isExperienceInvite,
		userId = userId,
		placeId = placeId
	})

	return callback(string.format("%s/send-game-link-message", Url.CHAT_URL), "POST", {
		postBody = jsonEncode
	})
end
