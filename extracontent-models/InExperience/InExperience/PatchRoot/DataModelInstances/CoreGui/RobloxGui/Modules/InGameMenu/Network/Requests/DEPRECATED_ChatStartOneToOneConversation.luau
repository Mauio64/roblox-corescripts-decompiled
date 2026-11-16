local HttpService = game:GetService("HttpService")

local parent = script.Parent.Parent.Parent
local Url = require(parent.Network.Url)

return function(callback, participantuserId, _)
	local jsonEncode = HttpService:JSONEncode({ participantuserId = participantuserId })

	return callback(string.format("%s/start-one-to-one-conversation", Url.CHAT_URL), "POST", {
		postBody = jsonEncode
	})
end
