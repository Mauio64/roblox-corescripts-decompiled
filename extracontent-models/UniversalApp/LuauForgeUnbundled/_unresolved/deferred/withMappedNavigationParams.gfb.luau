local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dwM")
local module2 = require("@luauforge/bundled/fsM")

local function withMappedNavigationParams(p2, options)
	module.assert(
		module2(p2),
		"withMappedNavigationParams must be called with a Roact component (stateful or functional)"
	)

	local v5 = options or {}

	if v5.forwardRef == nil then
		v5.forwardRef = true
	end

	return function(p3)
		local params = p3.navigation.state.params or {}
		return Roact.createElement(p2, Cryo.Dictionary.join(p3, params, {
			[Roact.Ref] = v5.forwardRef and p3[Roact.Ref] or Cryo.None
		}))
	end
end

return withMappedNavigationParams
