local Parent = script:FindFirstAncestor("ChallengeDialog").Parent
local HttpService = game:GetService("HttpService")
local Url = require(Parent.Http).Url

return function(p1, p2, p3) -- line: 7
	-- upvalues: Url (copy), HttpService (copy)
	return p1(string.format("%schallenge-dialog-service/v1/dialogs", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			dialog = p2,
			action = p3
		})
	})
end
