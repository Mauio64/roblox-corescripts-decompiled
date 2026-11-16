local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local Http = require(parent.Http)

local function getAccounts(callback)
	return callback(("%s/users/authenticated/app-launch-info"):format(Http.Url.USERS_URL), "GET")
end

return getAccounts
