require("@luauforge/bundled/hKp")

require("@luauforge/bundled/hKr")

local function resolveRoutes(callback)
	if typeof(callback) == "function" then
		return callback()
	end

	return callback
end

local function createConfig(data)
	local content = data.content

	if typeof(content) == "function" then
		return table.freeze({ name = data.name, view = content, options = data.options })
	end

	return table.freeze({
		name = data.name,
		view = content.layout,
		options = data.options,
		navigator = content.config
	})
end

local function createRouteConfigs(routes)
	local v5 = {}
	local v6, v7

	if typeof(routes) == "function" then
		routes, v6, v7 = routes()
	end

	for k, v8 in routes, v6, v7 do
		table.insert(v5, createConfig(v8))
	end

	return table.freeze(v5)
end

local function defineNavigator(p2, data)
	return table.freeze({
		layout = data.layout,
		config = table.freeze({
			type = p2,
			routes = function()
				return createRouteConfigs(data.routes)
			end,
			initial = data.initial
		})
	})
end

return defineNavigator
