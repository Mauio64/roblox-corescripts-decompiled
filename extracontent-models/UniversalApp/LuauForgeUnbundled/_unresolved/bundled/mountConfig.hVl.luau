require("@luauforge/bundled/hUX")

local module = require("@luauforge/bundled/hVk")

local function mountConfig(data, p2, data2)
	local navigator = data.navigator

	if navigator == nil then
		return module(data.name, p2, data.options, nil, data2.navigator)
	end

	local v5 = data2.mount(data.name, p2, data.options, navigator)
	local route = v5.navigator.route
	data2.children[route.key] = v5
	return route
end

return mountConfig
