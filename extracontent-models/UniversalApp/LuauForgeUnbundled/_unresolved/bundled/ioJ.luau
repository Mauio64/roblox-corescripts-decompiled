local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/ioH")

local module2 = require("@luauforge/bundled/haM")
local module3 = require("@luauforge/bundled/ioK")

local v5 = { "setBodyColors", "setAvatarScales" }

return function(p2)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState({})

	React.useEffect(function()
		local v6, v7, v8 = module(v5)
		setState(v6)
		setState2(v7)
		return function()
			for k, v9 in v8 do
				v9()
			end
		end
	end, {})

	return React.createElement(module2.Provider, { value = state2 }, {
		BodyDataEventsContextProvider = React.createElement(
			module3.Provider,
			{ value = state },
			p2.children
		)
	})
end
