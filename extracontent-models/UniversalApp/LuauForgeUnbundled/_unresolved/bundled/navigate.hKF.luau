require("@luauforge/bundled/hKp")

local module = require("@luauforge/bundled/hKD")

local function findRouteIndex(items, p2)
	for k, item in items do
		if item.name == p2 then
			return k
		end
	end

	return nil
end

local function copyRoutes(items)
	local result = {}

	for k, item in items do
		table.insert(result, item)
	end

	return result
end

local function setRoutes(p2, p3, p4)
	p2.setState(table.freeze({ index = p3, routes = p4 }))
end

local function mergeParams(params, items)
	if items == nil or typeof(items) ~= "table" or next(items) == nil then
		return params
	end

	local result = typeof(params) ~= "table" and {} or table.clone(params)

	for k, item in items do
		result[k] = item
	end

	return result
end

local function paramsEqual(params, items): boolean
	if params == items then
		return true
	end

	if typeof(params) ~= "table" or typeof(items) ~= "table" then
		return false
	end

	for k, item in params do
		if items[k] ~= item then
			return false
		end
	end

	for k, item in items do
		if params[k] ~= item then
			return false
		end
	end

	return true
end

local function cloneRoute(data, p2)
	return table.freeze({
		key = data.key,
		name = data.name,
		params = p2,
		options = data.options,
		focused = data.focused,
		state = data.state
	})
end

local function navigate(data, p2, p3): boolean
	local v5 = data.registry[p2.name]

	if v5 == nil then
		return false
	end

	if data.navigator.type == "switch" then
		local state = data.getState(false)
		local routes = state.routes
		local name = p2.name
		local v6 = nil

		for k, route in routes do
			if route.name == name then
				v6 = k
				break
			end
		end

		if v6 == nil then
			return false
		end

		local route = state.routes[v6]
		local v8 = mergeParams(route.params, p3)
		local v9

		if paramsEqual(route.params, v8) then
			v9 = route
		else
			v9 = table.freeze({
				key = route.key,
				name = route.name,
				params = v8,
				options = route.options,
				focused = route.focused,
				state = route.state
			})
		end

		if v9 == route then
			if state.index ~= v6 then
				local routes2 = state.routes
				data.setState(table.freeze({ index = v6, routes = routes2 }))
			end

			return true
		else
			local v10 = {}

			for k, route2 in state.routes do
				table.insert(v10, route2)
			end

			v10[v6] = v9
			local frozen = table.freeze(v10)
			data.setState(table.freeze({ index = v6, routes = frozen }))

			return true
		end
	else
		local v6 = {}

		for k, route in data.getState(false).routes do
			table.insert(v6, route)
		end

		table.insert(v6, module(v5, p3, data))
		local v7 = #v6
		local frozen = table.freeze(v6)
		data.setState(table.freeze({ index = v7, routes = frozen }))

		return true
	end
end

return navigate
