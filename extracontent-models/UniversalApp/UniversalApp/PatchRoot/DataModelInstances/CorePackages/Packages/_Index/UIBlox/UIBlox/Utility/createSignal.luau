local function createSignal()
	local v = {}
	local v2 = {}
	local v3 = false

	return {
		subscribe = function(_, callback)
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
		end,
		fire = function(_, ...)
			v3 = true

			for k, v4 in pairs(v) do
				if not (v4.disconnected or v2[k]) then
					k(...)
				end
			end

			v3 = false

			for k, _ in pairs(v2) do
				v2[k] = nil
			end
		end
	}
end

return createSignal
