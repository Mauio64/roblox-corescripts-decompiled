local Parent = script:FindFirstAncestor("PlayerFeedback").Parent
local GetFStringEdpPlayerFeedbackServiceRoute = require(Parent.SharedFlags).GetFStringEdpPlayerFeedbackServiceRoute
local Url = require(Parent.Http).Url

return function(p1, s1: string, s2: string) -- line: 10
	-- upvalues: Url (copy), GetFStringEdpPlayerFeedbackServiceRoute (copy)
	assert(type(s1) == "string", "GamesGetPlayerFeedbackMetadata request expects channelId to be a string")
	assert(type(s2) == "string", "GamesGetPlayerFeedbackMetadata request expects assetId to be a string")

	return p1(string.format("%s%s/v1/channels/%s/assets/%s", Url.APIS_URL, GetFStringEdpPlayerFeedbackServiceRoute(), s1, s2), "GET")
end
