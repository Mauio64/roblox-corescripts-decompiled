local reportMomentsRealtimeEvent = require(script.Parent.reportMomentsRealtimeEvent)

local v = {
	schedule = function(duration: number, callback)
		return task.delay(duration, callback)
	end,
	cancel = function(thread: thread)
		task.cancel(thread)
	end
}

local function createMomentsSessionHeartbeat(value: number?, callback, p)
	local v2 = value or 60

	local v3 = callback or reportMomentsRealtimeEvent.reportMomentsSessionHeartbeat
	local v4 = p or v
	local v5 = nil
	local v6 = nil
	local function tick()
		if v6 == nil then
			return
		end

		v3(v6)
		v5 = v4.schedule(v2, tick)
	end

	local function stop() -- 1 equivalent call inferred from this helper
		if v5 ~= nil then
			v4.cancel(v5)
			v5 = nil
		end

		v6 = nil
	end

	return {
		start = function(p2: string)
			stop() -- inferred equivalent call
			v6 = p2
			v5 = v4.schedule(v2, tick)
		end,
		stop = stop
	}
end

return createMomentsSessionHeartbeat
