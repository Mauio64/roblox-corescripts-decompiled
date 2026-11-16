local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")
local module2 = require("@luauforge/bundled/dxP")

return Rodux.createReducer("", {
	[module2.name] = function(p2, p3)
		local bundleId = p3.bundleId
		module.isTypeOrNil(bundleId, "string", "action.bundleId from SetSignUpSelectedBundleId")
		return bundleId
	end
})
