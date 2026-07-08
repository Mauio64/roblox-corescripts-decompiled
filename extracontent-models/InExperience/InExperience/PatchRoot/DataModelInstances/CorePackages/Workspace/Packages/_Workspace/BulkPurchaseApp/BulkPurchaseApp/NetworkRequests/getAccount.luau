local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local Http = require(Parent.Http)

local function getAccounts(p1) -- line: 5
	-- upvalues: Http (copy)
	return p1(("%s/users/authenticated/app-launch-info"):format(Http.Url.USERS_URL), "GET")
end

return getAccounts
