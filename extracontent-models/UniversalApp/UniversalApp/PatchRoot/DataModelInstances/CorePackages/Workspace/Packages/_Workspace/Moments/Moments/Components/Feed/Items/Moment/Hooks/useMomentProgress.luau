local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local MomentContext = require(script.Parent.Parent.MomentContext)
local t1 = {
	time = 0,
	duration = 0,
	ratio = 0
}

local function useMomentProgress() -- line: 20
	-- upvalues: MomentContext (copy), Signals (copy), t1 (copy)
	local v6 = MomentContext.useMoment()

	return (Signals.createComputed(function(p1) -- line: 23
		-- upvalues: v6 (copy), t1 (copy)
		local controller = v6.controller

		if controller == nil then
			return t1
		end

		local v9 = controller.getPosition(p1)
		local duration = controller.getState(p1).duration

		if duration <= 0 then
			return t1
		end

		return {
			time = v9,
			duration = duration,
			ratio = v9 / duration
		}
	end))
end

return useMomentProgress
