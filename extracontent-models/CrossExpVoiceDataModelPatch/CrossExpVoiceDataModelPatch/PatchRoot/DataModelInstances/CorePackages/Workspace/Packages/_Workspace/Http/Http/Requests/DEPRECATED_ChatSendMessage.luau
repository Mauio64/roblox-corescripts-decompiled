local HttpService = game:GetService("HttpService")

local Http = script:FindFirstAncestor("Http")
local Url = require(Http.Url)
require(Http.RequestTypes)

return function(callback, conversationId, message, decorators, isExperienceInvite: boolean?, userId: number?)
	local jsonEncode = HttpService:JSONEncode({
		conversationId = conversationId,
		message = message,
		decorators = decorators,
		isExperienceInvite = isExperienceInvite,
		userId = userId
	})

	return callback(string.format("%s/send-message", Url.CHAT_URL), "POST", {
		postBody = jsonEncode
	})
end
