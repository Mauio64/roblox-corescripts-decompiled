local reportMomentsRealtimeEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/reportMomentsRealtimeEvent")

local v5 = {
	schedule = function(duration, callback)
		return task.delay(duration, callback)
	end,
	cancel = function(p2)
		task.cancel(p2)
	end
}

local function createMomentsSessionHeartbeat(value, p2, p3)
	local v6 = value or 60

	local v7 = p2 or reportMomentsRealtimeEvent.reportMomentsSessionHeartbeat
	local v8 = p3 or v5
	local v9 = nil
	local v10 = nil
	local function tick2()
		if v10 == nil then
			return
		end

		v7(v10)
		v9 = v8.schedule(v6, tick2)
	end

	return {
		start = function(p4)
			if v9 ~= nil then
				v8.cancel(v9)
				v9 = nil
			end

			v10 = nil

			v10 = p4
			v9 = v8.schedule(v6, tick2)
		end,
		stop = function()
			if v9 ~= nil then
				v8.cancel(v9)
				v9 = nil
			end

			v10 = nil
		end
	}
end

return createMomentsSessionHeartbeat
