local module = require("@luauforge/bundled/hxA")
local url = require("@luauforge/bundled/hxE").Url

local function decode(p2)
	local v5 = typeof(p2) ~= "table" and {} or p2
	local v6 = {
		isEligible = v5.isEligible == true,
		failureReason = typeof(v5.failureReason) ~= "string" and "" or v5.failureReason,
		expirationTimeInMinutes = 0
	}
	local v7 = if typeof(v5.expirationTimeInMinutes) == "number" and v5.expirationTimeInMinutes > 0 then v5.expirationTimeInMinutes else nil
	v6.expirationTimeInMinutes = v7
	return v6
end

local function checkUserPurchaseSettings(p2)
	return module.asPromise(module.fetch({
		network = p2,
		method = "POST",
		url = `{url.APIS_URL}payments-gateway/v1/check-user-purchase-settings`,
		body = {},
		analyticsKey = "payments-gateway.v1.check-user-purchase-settings",
		decode = decode,
		retry = false,
		headers = {}
	}))
end

return checkUserPurchaseSettings
