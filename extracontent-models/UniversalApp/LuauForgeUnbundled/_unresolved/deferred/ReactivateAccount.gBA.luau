local url = require("@luauforge/deferred/gBj").Url

local function ReactivateAccount(callback)
	return callback(url.APIS_URL .. "account-deletion-api/v1/reactivate", "POST")
end

return ReactivateAccount
