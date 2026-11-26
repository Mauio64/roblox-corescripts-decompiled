local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/ioO")
local module2 = require("@luauforge/bundled/hhX")

return function(p2)
	local v5, v6 = React.useBinding(nil)
	local state, setState = React.useState({ appliedDescriptionBinding = v5 })

	local v7 = React.useCallback(function(p3)
		v6(p3)
	end, { v6 })
	React.useEffect(function()
		setState({ appliedDescriptionBinding = v5 })
	end, { v5 })

	local v8 = React.useMemo(function()
		return { setAppliedDescription = v7 }
	end, { v7 })

	return React.createElement(module.Provider, { value = v8 }, {
		AppliedDescriptionValueContextProvider = React.createElement(
			module2.Provider,
			{ value = state },
			p2.children
		)
	})
end
