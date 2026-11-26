local module = require("@luauforge/bundled/dVn")
local v5 = require("@luauforge/bundled/fzK").new({
	base = module.APIS_URL,
	path = "developer-subscriptions/v1/subscriptions",
	query = "{userId}&{status}&{includeLookupData}&{cursor|}"
})

local function getSubscriptions(callback, p2, p3, p4)
	return callback(v5({
		userId = p2,
		status = p3,
		cursor = p4,
		includeLookupData = "true"
	}), "GET")
end

return getSubscriptions
