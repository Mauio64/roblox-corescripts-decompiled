local function createSignal()
	local v = {}
	local v2 = {}
	local v3 = false

	local function subscribe(callback)
		assert(typeof(callback) == "function", "Can only subscribe to signals with a function.")

		local v4 = { callback = callback, disconnected = false }

		if v3 and not v[callback] then
			v2[callback] = v4
		end

		v[callback] = v4

		local function disconnect()
			assert(not v4.disconnected, "Listeners can only be disconnected once.")

			v4.disconnected = true
			v[callback] = nil
			v2[callback] = nil
		end

		return disconnect
	end

	local function fire(...)
		v3 = true

		for k, v4 in v do
			if not (v4.disconnected or v2[k]) then
				k(...)
			end
		end

		v3 = false

		table.clear(v2)
	end

	return subscribe, fire
end

local function fireConnections(items, ...): nil
	for k, item in items do
		if not item.disconnected then
			k(...)
		end
	end

	return nil
end

local function createReentrantSafeSignal()
	local v = {}
	local v2 = {}
	local v3 = 0

	local function subscribe(callback)
		assert(typeof(callback) == "function", "Can only subscribe to signals with a function.")

		local v4 = { callback = callback, disconnected = false }

		if v3 > 0 and v[callback] == nil then
			v2[callback] = v4
		else
			v[callback] = v4
		end

		local function disconnect()
			assert(not v4.disconnected, "Listeners can only be disconnected once.")

			v4.disconnected = true

			if v[callback] == v4 then
				v[callback] = nil
			end

			if v2[callback] == v4 then
				v2[callback] = nil
			end
		end

		return disconnect
	end

	local function fire(...)
		v3 += 1

		local success, result = pcall(fireConnections, v, ...)
		v3 -= 1

		if v3 == 0 and next(v2) ~= nil then
			for k, v4 in v2 do
				v[k] = v4
			end

			table.clear(v2)
		end

		if not success then
			error(result, 0)
		end
	end

	return subscribe, fire
end

local Shared = require(script.Parent.Parent.Shared)

if Shared.ReactFeatureFlags.enableReentrantSafeSignals then
	return createReentrantSafeSignal
end

return createSignal
