local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local reducerUtils = require("@luauforge/bundled/dHL").Utils.ReducerUtils
local module = require("@luauforge/bundled/dOY")

return (Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		return reducerUtils.convertDefaultBodyColorRanges(p3.defaultBodyColorRanges)
	end
}))
