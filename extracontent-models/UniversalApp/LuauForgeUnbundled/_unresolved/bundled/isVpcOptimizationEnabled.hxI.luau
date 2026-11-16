local module = require("@luauforge/bundled/hxA")
local module2 = require("@luauforge/bundled/hxC")
local url = require("@luauforge/bundled/hxE").Url

local function decode(p2): boolean
	return typeof(p2) == "table"
		and p2.texasU18VPCOptimizationEnabled == true
		and p2.texasU18VPCOptimizationEnabledForEveryone == true
end

local function isVpcOptimizationEnabled(p2)
	return module.asPromise(module.fetch({
		network = p2,
		method = "GET",
		url = `{url.APIS_URL}guac-v2/v1/bundles/texas-u18-vpc-optimization`,
		analyticsKey = "guac-v2.v1.bundles.texas-u18-vpc-optimization",
		decode = decode,
		retry = false,
		headers = {}
	})):catch(function()
		return module2.resolve(false)
	end)
end

return isVpcOptimizationEnabled
