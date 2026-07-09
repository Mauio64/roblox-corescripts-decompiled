local Parent = script:FindFirstAncestor("PromptAssignments").Parent
local Url = require(Parent.Http).Url

return function(p1) -- line: 17
	-- upvalues: Url (copy)
	return p1(string.format("%saccount-security-service/v1/prompt-assignments?shouldReturnMetadata=true", Url.APIS_URL), "GET")
end
