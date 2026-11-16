local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local createNavigator = RoactNavigation.createNavigator
local module = require("@luauforge/bundled/dCw")

local module2 = require("@luauforge/deferred/gkg")

return function(p2, options)
	local v5 = module2(p2, options)

	return createNavigator(module.AppStackView, v5, options or {})
end
