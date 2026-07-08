local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent.Parent
local Url = require(ParentParent.Network.Url)

return function(p1, p2, p3, p4) -- line: 7
	-- upvalues: HttpService (copy), Url (copy)
	local json = HttpService:JSONEncode({
		conversationId = p2,
		message = p3,
		decorators = p4
	})

	return p1(string.format("%s/send-message", Url.CHAT_URL), "POST", {
		postBody = json
	})
end
