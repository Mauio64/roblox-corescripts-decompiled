local module = require("@luauforge/bundled/hVa")

local module2 = require("@luauforge/bundled/hVj")

require("@luauforge/bundled/hUZ")

local module3 = require("@luauforge/bundled/hVo")
local module4 = require("@luauforge/bundled/hVp")

local function NavigationRoot(p2)
	local navigator = p2.navigator

	local v5 = module.useMemo(function()
		return module2("root", nil, nil, navigator.config)
	end, { navigator.config })

	local element = module.createElement(module3, {
		params = nil,
		tree = v5,
		layout = navigator.layout
	})

	return module.createElement(
		module4,
		{ route = v5.navigator.route, navigator = v5.navigator, visible = true },
		element
	)
end

return NavigationRoot
