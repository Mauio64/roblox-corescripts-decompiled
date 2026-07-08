local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent.Parent
local Url = require(ParentParent.Network.Url)

return function(p1, p2, _) -- line: 7
	-- upvalues: HttpService (copy), Url (copy)
	local json = HttpService:JSONEncode({
		participantuserId = p2
	})

	return p1(string.format("%s/start-one-to-one-conversation", Url.CHAT_URL), "POST", {
		postBody = json
	})
end
