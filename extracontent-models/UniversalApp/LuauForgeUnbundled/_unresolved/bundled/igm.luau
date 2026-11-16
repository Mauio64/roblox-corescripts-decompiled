local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/igi")

local module2 = require("@luauforge/bundled/gVZ")
local module3 = require("@luauforge/bundled/ign")

return function(p2)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState({})

	React.useEffect(function()
		local v5, v6, v7 = module({ "setAdjustments" })

		setState(v5)
		setState2(v6)
		return function()
			for k, v8 in v7 do
				v8()
			end
		end
	end, {})

	return React.createElement(module2.Provider, { value = state2 }, {
		AdjustmentDataEventsContextProvider = React.createElement(
			module3.Provider,
			{ value = state },
			p2.children
		)
	})
end
