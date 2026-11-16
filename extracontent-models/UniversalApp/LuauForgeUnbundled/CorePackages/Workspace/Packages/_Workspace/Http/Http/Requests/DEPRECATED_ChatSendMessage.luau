local HttpService = game:GetService("HttpService")

local Url = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Url")
require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/RequestTypes")

return function(callback, p2, p3, p4, p5, p6)
	local jsonEncode = HttpService:JSONEncode({
		conversationId = p2,
		message = p3,
		decorators = p4,
		isExperienceInvite = p5,
		userId = p6
	})

	return callback(string.format("%s/send-message", Url.CHAT_URL), "POST", {
		postBody = jsonEncode
	})
end
