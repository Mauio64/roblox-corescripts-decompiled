local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent.Parent
local Url = require(ParentParent.Network.Url)

return function(p1, p2, p3, p4) -- line: 7
	-- upvalues: HttpService (copy), Url (copy)
	assert(p1, "requestImpl is required")
	assert(p2, "conversationId is required")
	assert(p3, "universeId is required")

	local json = HttpService:JSONEncode({
		conversationId = p2,
		universeId = p3,
		decorators = p4
	})

	return p1(string.format("%s/send-game-link-message", Url.CHAT_URL), "POST", {
		postBody = json
	})
end
