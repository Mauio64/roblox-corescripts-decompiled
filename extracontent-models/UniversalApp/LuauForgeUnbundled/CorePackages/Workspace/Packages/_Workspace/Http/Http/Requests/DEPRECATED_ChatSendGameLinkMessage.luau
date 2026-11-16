local HttpService = game:GetService("HttpService")

local Url = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Url")
require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/RequestTypes")

return function(callback, p2, p3, p4, p5, p6, p7)
	assert(callback, "requestImpl is required")
	assert(p2, "conversationId is required")
	assert(p3, "universeId is required")

	local jsonEncode = HttpService:JSONEncode({
		conversationId = p2,
		universeId = p3,
		decorators = p4,
		isExperienceInvite = p5,
		userId = p6,
		placeId = p7
	})

	return callback(string.format("%s/send-game-link-message", Url.CHAT_URL), "POST", {
		postBody = jsonEncode
	})
end
