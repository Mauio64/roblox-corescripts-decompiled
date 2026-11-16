local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local MomentContext = require(script.Parent.Parent.MomentContext)

local v = { time = 0, duration = 0, ratio = 0 }

local function useMomentProgress()
	local v2 = MomentContext.useMoment()

	return (Signals.createComputed(function(p)
		local controller = v2.controller

		if controller == nil then
			return v
		end

		local position = controller.getPosition(p)
		local duration = controller.getState(p).duration

		if duration <= 0 then
			return v
		end

		return {
			time = position,
			duration = duration,
			ratio = position / duration
		}
	end))
end

return useMomentProgress
