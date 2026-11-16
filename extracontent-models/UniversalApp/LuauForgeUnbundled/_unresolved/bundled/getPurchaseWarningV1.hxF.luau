local module = require("@luauforge/bundled/hxA")
local module2 = require("@luauforge/bundled/hxC")
local url = require("@luauforge/bundled/hxE").Url

local module3 = require("@luauforge/bundled/hxp")

local function decode(p2)
	local action = if typeof(p2) == "table" then p2.action else nil

	if typeof(action) == "string" then
		return action
	end

	return module3.NoAction
end

local function getPurchaseWarningV1(p2, p3, p4)
	return module.asPromise(module.fetch({
		network = p4,
		method = "GET",
		url = `{url.APIS_URL}purchase-warning/v1/purchase-warnings?productId={p2}&is13To17ScaryModalEnabled={p3}`,
		analyticsKey = "purchase-warning.v1.purchase-warnings",
		decode = decode,
		retry = false,
		headers = {}
	})):catch(function()
		return module2.resolve(module3.NoAction)
	end)
end

return getPurchaseWarningV1
