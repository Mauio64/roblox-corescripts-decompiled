local Parent = script:FindFirstAncestor("Foundation").Parent

require(Parent.React)

local useClock = require(Parent.ReactUtils).useClock

local function useRotation(n1: number?) -- line: 11
	-- upvalues: useClock (copy)
	return useClock():map(function(n2: number) -- line: 14
		-- upvalues: n1 (copy)
		return n2 * 360 * (n1 or 1)
	end)
end

return useRotation
