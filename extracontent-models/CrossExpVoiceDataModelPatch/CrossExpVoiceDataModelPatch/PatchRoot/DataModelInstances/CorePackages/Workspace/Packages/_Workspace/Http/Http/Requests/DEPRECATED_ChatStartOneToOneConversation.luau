local HttpService = game:GetService("HttpService")

local Url = require(script.Parent.Parent.Url)

return function(callback, participantuserId, _)
	local jsonEncode = HttpService:JSONEncode({ participantuserId = participantuserId })

	return callback(string.format("%s/start-one-to-one-conversation", Url.CHAT_URL), "POST", {
		postBody = jsonEncode
	})
end
