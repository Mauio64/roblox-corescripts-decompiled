local function addToMap(items, p, p2)
	local result = {}

	for k, item in pairs(items) do
		result[k] = item
	end

	result[p] = p2

	return result
end

local function removeFromMap(items, callback) -- 1 equivalent call inferred from this helper
	local result = {}

	for k, item in pairs(items) do
		if k ~= callback then
			result[k] = item
		end
	end

	return result
end

local function createSignal()
	local v = {}

	return {
		subscribe = function(_, callback)
			assert(typeof(callback) == "function", "Can only subscribe to signals with a function.")

			local v2 = v
			local v3 = {}

			local v4 = { callback = callback }

			for k, v5 in pairs(v2) do
				v3[k] = v5
			end

			v3[callback] = v4

			v = v3

			local function disconnect()
				assert(not v4.disconnected, "Listeners can only be disconnected once.")

				v4.disconnected = true
				v = removeFromMap(v, callback) -- inferred equivalent call
			end

			return disconnect
		end,
		fire = function(_, ...)
			for k, v2 in pairs(v) do
				if not v2.disconnected then
					k(...)
				end
			end
		end
	}
end

return createSignal
