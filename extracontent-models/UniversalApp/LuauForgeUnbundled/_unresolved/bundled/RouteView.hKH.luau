local module = require("@luauforge/bundled/hKs")

require("@luauforge/bundled/hKp")

local module2 = require("@luauforge/bundled/hKt")
local module3 = require("@luauforge/bundled/hKv")
local module4 = require("@luauforge/bundled/hKw")

local function useParentVisible(): boolean
	return module.useContext(module3.VisibleContext) ~= false
end

local function RouteView(props)
	local visible = module.useContext(module3.VisibleContext) ~= false and props.visible

	local children = props.children

	local element = module.createElement(module2.RouteContext.Provider, {
		value = props.route
	}, children)

	local element2 = module.createElement(module3.VisibleContext.Provider, {
		value = visible
	}, element)

	if props.navigator ~= nil then
		element2 = module.createElement(
			module4.NavigatorContext.Provider,
			{ value = props.navigator },
			element2
		)
	end

	return element2
end

return RouteView
