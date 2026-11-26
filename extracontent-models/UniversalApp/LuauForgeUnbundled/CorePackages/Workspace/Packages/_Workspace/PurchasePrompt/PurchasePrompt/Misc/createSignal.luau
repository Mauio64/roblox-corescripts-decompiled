local function addToMap(p2, p3, p4)
	local clone = table.clone(p2)

	clone[p3] = p4

	return clone
end

local function removeFromMap(items, p2)
	local result = {}

	for k, item in pairs(items) do
		if k ~= p2 then
			result[k] = item
		end
	end

	return result
end

local function createSignal()
	local v5 = {}

	return {
		subscribe = function(p2, callback)
			assert(typeof(callback) == "function", "Can only subscribe to signals with a function.")

			local v6 = { callback = callback, disconnected = false }

			local v7 = v5
			local clone = table.clone(v7)

			clone[callback] = v6

			v5 = clone

			local function disconnect()
				assert(not v6.disconnected, "Listeners can only be disconnected once.")

				v6.disconnected = true
				local v8 = v5
				local v9 = callback
				local v10 = {}

				for k, v11 in pairs(v8) do
					if k ~= v9 then
						v10[k] = v11
					end
				end

				v5 = v10
			end

			return disconnect
		end,
		fire = function(p2, ...)
			for k, v6 in pairs(v5) do
				if not v6.disconnected then
					k(...)
				end
			end
		end
	}
end

return createSignal
