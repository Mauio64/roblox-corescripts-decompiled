local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dwM")

local module2 = require("@luauforge/bundled/fsM")
require(CorePackages.Packages.Dash)

local v5 = { forwardRef = true, required = true }

local function withContextValue(p2, p3, p4, options)
	module.assert(
		module2(p2),
		"withContextValue must be called with a Roact component (stateful or functional)"
	)

	module.assert(module2(p3), "withContextValue must be called with a Roact component for contextConsumer")

	module.isType(p4, "string", "withContextValue propName")

	local joined = Cryo.Dictionary.join(v5, options or {})

	return function(p5)
		local v6 = p5[p4]
		return Roact.createElement(p3, {
			render = function(p6)
				local v7 = v6 or p6

				if joined.required then
					module.assert(
						v7,
						string.format(
							"withContextValue can only be used within the context provider hierarchy. The wrapped component %q is unable to get access to %q from props or context.",
							tostring(p2),
							p4
						)
					)
				end

				return Roact.createElement(p2, Cryo.Dictionary.join(p5, {
					[p4] = v7,
					[Roact.Ref] = joined.forwardRef and p5[Roact.Ref] or nil
				}))
			end
		})
	end
end

return withContextValue
