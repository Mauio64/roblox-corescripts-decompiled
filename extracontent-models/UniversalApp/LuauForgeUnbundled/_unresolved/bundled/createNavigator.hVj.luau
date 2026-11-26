local module = require("@luauforge/bundled/hUY")

require("@luauforge/bundled/hUX")

local module2 = require("@luauforge/bundled/hVk")
local module3 = require("@luauforge/bundled/hVl")

local module4 = require("@luauforge/bundled/hVm")
local module5 = require("@luauforge/bundled/hVn")

local frozen = table.freeze({ index = 0, routes = table.freeze({}) })

local function resolveRoutes(p2)
	local routes = p2.routes

	if typeof(routes) == "function" then
		return routes()
	end

	return routes
end

local function createRegistry(items)
	local v5 = {}

	for k, item in items do
		v5[item.name] = item
	end

	return table.freeze(v5)
end

local function findInitialIndex(items, p2)
	if p2 == nil then
		return 1
	end

	for k, item in items do
		if item.name == p2.name then
			return k
		end
	end

	error(`missing initial route "{p2.name}"`)
end

local function createNavigator(p2, p3, p4, data, frozen2)
	local v5 = data.routes

	if typeof(v5) == "function" then
		v5 = v5()
	end

	local signal, v6 = module.createSignal(frozen)

	local navigator = if frozen2 ~= nil then frozen2.navigator else nil
	local v7 = module2(p2, p3, p4, signal, navigator)

	local frozen3 = nil

	local frozen4 = table.freeze({
		type = data.type,
		route = v7,
		back = function()
			return module4(frozen3)
		end,
		navigate = function(p5, p6)
			return module5(frozen3, p5, p6)
		end,
		dispatch = function(callback)
			return callback(frozen3)
		end,
		child = function(p5)
			local v8 = signal(false)
			local routes = v8.routes

			if p5 == nil then
				p5 = v8.index
			end

			local route = routes[p5]
			local v9 = if route ~= nil then frozen3.children[route.key] else nil

			if v9 == nil then
				return nil
			end

			return v9.navigator
		end,
		parent = function()
			return navigator
		end
	})

	local freeze = table.freeze
	local v8 = {
		getState = signal,
		setState = v6,
		navigator = frozen4,
		parent = frozen2,
		mount = function(p5, p6, p7, p8)
			return createNavigator(p5, p6, p7, p8, frozen3)
		end,
		routes = v5,
		registry = 0,
		children = 0
	}
	local v9 = {}

	for k, v10 in v5 do
		v9[v10.name] = v10
	end

	v8.registry = table.freeze(v9)
	v8.children = {}
	frozen3 = freeze(v8)

	if #v5 == 0 then
		return frozen3
	end

	local initial = data.initial
	local v10

	if initial == nil then
		v10 = 1
	else
		local flag = true

		for k, v11 in v5 do
			if v11.name == initial.name then
				v10 = k
				flag = false
				break
			end
		end

		if flag then
			error(`missing initial route "{initial.name}"`)
		end
	end

	local v11 = {}

	if frozen3.navigator.type == "switch" then
		for k, v12 in v5 do
			table.insert(v11, module3(v12, nil, frozen3))
		end

		frozen3.setState(table.freeze({ index = v10, routes = table.freeze(v11) }))
	else
		table.insert(v11, module3(v5[v10], nil, frozen3))
		frozen3.setState(table.freeze({ index = 1, routes = table.freeze(v11) }))
	end

	return frozen3
end

return createNavigator
