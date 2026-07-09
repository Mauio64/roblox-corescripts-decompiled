local Parent = script:FindFirstAncestor("NotApprovedPage").Parent
local Url = require(Parent.Http).Url

local function GetCommutationEligibility(p1) -- line: 19
	-- upvalues: Url (copy)
	return p1(Url.APIS_URL .. "moderation-appeal-service/v2/consequence-commutation-eligibility", "GET")
end

return GetCommutationEligibility
