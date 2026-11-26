local module = require("@luauforge/bundled/hVa")
local module2 = require("@luauforge/bundled/hVc")

require("@luauforge/bundled/hUX")

require("@luauforge/bundled/hUZ")

local module3 = require("@luauforge/bundled/hVp")

local function createDescriptor(route, p2, element)
	return table.freeze({
		route = route,
		options = route.options,
		render = function(p3)
			local v5 = p3 == nil or p3.visible ~= false
			return module.createElement(module3, {
				route = route,
				navigator = p2,
				visible = v5
			}, element)
		end
	})
end

local function NavigatorView(props)
	local tree = props.tree
	local v5 = module2.useSignalState(tree.getState)

	local v6 = module.useMemo(function()
		local v7 = {}

		for k, route in v5.routes do
			local v8 = tree.registry[route.name]
			local child = tree.children[route.key]

			if child == nil then
				local element = module.createElement(v8.view, {
					params = route.params,
					route = route
				})

				v7[route.key] = createDescriptor(route, nil, element)
			else
				local element = module.createElement(NavigatorView, {
					params = route.params,
					tree = child,
					layout = v8.view
				})

				v7[route.key] = createDescriptor(route, child.navigator, element)
			end
		end

		return table.freeze(v7)
	end, { tree, v5.routes })

	return module.createElement(props.layout, {
		params = props.params,
		state = v5,
		navigator = tree.navigator,
		descriptors = v6
	})
end

return NavigatorView
