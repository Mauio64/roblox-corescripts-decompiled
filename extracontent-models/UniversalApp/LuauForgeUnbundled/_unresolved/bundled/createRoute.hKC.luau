local module = require("@luauforge/bundled/hKq")

require("@luauforge/bundled/hKp")

local function createKey(p2)
	return `{p2}-{os.clock()}-{math.random(1000000)}`
end

local signal = module.createSignal(true)

local function createFocused(p2, p3)
	if p2 == nil then
		return signal
	end

	return module.createComputed(function(p4): boolean
		if not p2.route.focused(p4) then
			return false
		end

		local state = p2.route.state

		if state == nil then
			return false
		end

		local v5 = state(p4)
		local route = v5.routes[v5.index]
		return route ~= nil and route.key == p3
	end)
end

local function resolveOptions(callback, p2)
	if callback == nil then
		return nil
	end

	if typeof(callback) == "function" then
		return callback(p2)
	end

	return callback
end

local function createRoute(p2, p3, options, state, p4)
	local formatted = `{p2}-{os.clock()}-{math.random(1000000)}`

	local v5 = {
		key = formatted,
		name = p2,
		params = p3,
		focused = 0,
		state = 0
	}
	local v6

	if p4 == nil then
		v6 = signal
	else
		v6 = module.createComputed(function(p5): boolean
			if not p4.route.focused(p5) then
				return false
			end

			local state2 = p4.route.state

			if state2 == nil then
				return false
			end

			local v7 = state2(p5)
			local route = v7.routes[v7.index]
			return route ~= nil and route.key == formatted
		end)
	end

	v5.focused = v6
	v5.state = state

	if options == nil then
		options = nil
	elseif typeof(options) == "function" then
		options = options(v5)
	end

	v5.options = options
	return table.freeze(v5)
end

return createRoute
