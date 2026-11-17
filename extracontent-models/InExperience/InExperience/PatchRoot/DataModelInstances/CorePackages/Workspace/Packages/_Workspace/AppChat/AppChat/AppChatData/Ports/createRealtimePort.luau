local function createRealtimePort(callback)
	local v = nil

	local function getReceiver()
		local v2 = v

		if v2 ~= nil then
			return v2
		end

		local v3 = callback()
		v = v3
		return v3
	end

	return {
		observe = function(p: string, callback2)
			local v2 = v

			if v2 == nil then
				v2 = callback()
				v = v2
			end

			local v3 = v2:observeEvent(p, callback2)
			return function()
				v3:disconnect()
			end
		end
	}
end

return createRealtimePort
