local Achievements = script:FindFirstAncestor("Achievements")
local AchievementsParent = Achievements.Parent
local LuauPolyfill = require(AchievementsParent.LuauPolyfill)
local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval
local Logger = require(Achievements.Logger)

require(AchievementsParent.Signal)

return {
	init = function(t1: {[any]: any}, p1, n1: number) -- line: 25
		t1.fireDataChanged = p1
		t1.intervalInSec = n1
	end,
	start = function(p2) -- line: 30
		-- upvalues: setInterval (copy)
		p2.timerId = setInterval(p2.check, p2.intervalInSec * 1000, p2)
		p2.startTime = os.time()
	end,
	check = function(p3) -- line: 35
		-- upvalues: Logger (copy)
		if p3.startTime then
			local v12 = os.time() - p3.startTime

			p3.fireDataChanged(v12)

			return
		end

		Logger:error("No recorded start time")
	end,
	stop = function(p4) -- line: 44
		-- upvalues: clearInterval (copy)
		if p4.timerId then
			clearInterval(p4.timerId)
			p4.startTime = nil
		end
	end
}
