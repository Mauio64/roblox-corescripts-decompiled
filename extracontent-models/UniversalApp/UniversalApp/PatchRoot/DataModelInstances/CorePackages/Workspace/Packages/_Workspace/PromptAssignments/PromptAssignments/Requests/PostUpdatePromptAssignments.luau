local PromptAssignments = script:FindFirstAncestor("PromptAssignments")
local HttpService = game:GetService("HttpService")
local PromptAssignmentsParent = PromptAssignments.Parent
local Url = require(PromptAssignmentsParent.Http).Url

return function(p1, p2, p3) -- line: 14
	-- upvalues: Url (copy), HttpService (copy)
	return p1(string.format("%saccount-security-service/v1/prompt-assignments", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			promptType = p2,
			action = p3
		})
	})
end
