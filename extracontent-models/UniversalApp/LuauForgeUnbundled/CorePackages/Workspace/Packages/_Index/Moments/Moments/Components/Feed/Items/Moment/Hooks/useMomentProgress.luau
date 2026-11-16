local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")

local v5 = { time = 0, duration = 0, ratio = 0 }

local function useMomentProgress()
	local v6 = MomentContext.useMoment()

	return (Signals.createComputed(function(p2)
		local controller = v6.controller

		if controller == nil then
			return v5
		end

		local position = controller.getPosition(p2)
		local duration = controller.getState(p2).duration

		if duration <= 0 then
			return v5
		end

		return {
			time = position,
			duration = duration,
			ratio = position / duration
		}
	end))
end

return useMomentProgress
