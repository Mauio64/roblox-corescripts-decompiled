local parent = script:FindFirstAncestor("Foundation").Parent

require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useClock = ReactUtils.useClock

local function useRotation(value: number?)
	return useClock():map(function(p: number)
		return p * 360 * (value or 1)
	end)
end

return useRotation
