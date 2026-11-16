local function addToMap(p, callback, p2) -- 1 equivalent call inferred from this helper
	local clone = table.clone(p)

	clone[callback] = p2

	return clone
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

			local v2 = { callback = callback, disconnected = false }

			v = addToMap(v, callback, v2) -- inferred equivalent call

			local function disconnect()
				assert(not v2.disconnected, "Listeners can only be disconnected once.")

				v2.disconnected = true
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
