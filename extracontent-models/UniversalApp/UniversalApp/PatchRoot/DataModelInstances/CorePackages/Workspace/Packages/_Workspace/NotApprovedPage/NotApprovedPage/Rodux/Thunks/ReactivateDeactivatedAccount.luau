local Parent = script:FindFirstAncestor("NotApprovedPage").Parent
local Url = require(Parent.Http).Url

local function ReactivateAccount(p1) -- line: 7
	-- upvalues: Url (copy)
	return p1(Url.APIS_URL .. "account-deletion-api/v1/reactivate", "POST")
end

return ReactivateAccount
