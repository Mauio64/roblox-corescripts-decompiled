local CorePackages = game:GetService("CorePackages")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/ecV")
local module2 = require("@luauforge/deferred/guQ")

local module3 = require("@luauforge/bundled/frD")
local enumerate = require(CorePackages.Packages.enumerate)

local v6 = {
	None = "None",
	PurchaseNotEnabled = "PurchaseNotEnabled",
	SpendLimitExceeded = "SpendLimitExceeded"
}
local v5 = {}

v5.FailureReason = enumerate("ApiPostCheckUserPurchaseSettings", v6)
module3(v5.FailureReason, v6)

function v5.Post(p2)
	return performFetch.Single("PostCheckUserPurchaseSettings", function(p3)
		return module2(p2):andThen(function(list)
			local item = list[1]
			return module.resolve(item)
		end, function(p4)
			return module.resolve()
		end)
	end)
end

return v5
