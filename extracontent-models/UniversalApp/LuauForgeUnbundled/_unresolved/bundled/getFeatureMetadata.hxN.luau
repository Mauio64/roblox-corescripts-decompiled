local module = require("@luauforge/bundled/hxA")
local module2 = require("@luauforge/bundled/hxC")
local url = require("@luauforge/bundled/hxE").Url

local function decode(p2): boolean
	return typeof(p2) == "table" and p2.shouldShowFirstTimePurchaseConsent == true
end

local function getFeatureMetadata(p2, p3)
	return module.asPromise(module.fetch({
		network = p3,
		method = "GET",
		url = `{url.APIS_URL}payments-gateway/v1/feature/metadata?userId={p2}`,
		analyticsKey = "payments-gateway.v1.feature.metadata",
		decode = decode,
		retry = false,
		headers = {}
	})):catch(function()
		return module2.resolve(false)
	end)
end

return getFeatureMetadata
