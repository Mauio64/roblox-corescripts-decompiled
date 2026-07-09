local Parent = script:FindFirstAncestor("ChallengeDialog").Parent
local Url = require(Parent.Http).Url

return function(p1) -- line: 6
	-- upvalues: Url (copy)
	return p1(string.format("%schallenge-dialog-service/v1/dialogs", Url.APIS_URL), "GET")
end
