local HttpService = game:GetService("HttpService")
local Http = script:FindFirstAncestor("Http")
local Url = require(Http.Url)

require(Http.RequestTypes)

return function(p1, p2, p3, p4, b1: boolean?, n1: number?) -- line: 8
	-- upvalues: HttpService (copy), Url (copy)
	local json = HttpService:JSONEncode({
		conversationId = p2,
		message = p3,
		decorators = p4,
		isExperienceInvite = b1,
		userId = n1
	})

	return p1(string.format("%s/send-message", Url.CHAT_URL), "POST", {
		postBody = json
	})
end
