local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/LuauPolyfill")
local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Logger")
require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Signal")

return {
	init = function(p2, fireDataChanged, intervalInSec)
		p2.fireDataChanged = fireDataChanged
		p2.intervalInSec = intervalInSec
	end,
	start = function(state)
		state.timerId = setInterval(state.check, state.intervalInSec * 1000, state)
		state.startTime = os.time()
	end,
	check = function(p2)
		if not p2.startTime then
			Logger:error("No recorded start time")

			return
		end

		local v5 = os.time() - p2.startTime
		p2.fireDataChanged(v5)
	end,
	stop = function(p2)
		if p2.timerId then
			clearInterval(p2.timerId)
			p2.startTime = nil
		end
	end
}
