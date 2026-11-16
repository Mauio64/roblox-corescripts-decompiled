local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local v5 = require("@luauforge/bundled/fsq").new({
	base = Url.APIS_URL,
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
