local HttpService = game:GetService("HttpService")

local Url = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Url")

return function(callback, p2, p3)
	local jsonEncode = HttpService:JSONEncode({ participantuserId = p2 })

	return callback(string.format("%s/start-one-to-one-conversation", Url.CHAT_URL), "POST", {
		postBody = jsonEncode
	})
end
