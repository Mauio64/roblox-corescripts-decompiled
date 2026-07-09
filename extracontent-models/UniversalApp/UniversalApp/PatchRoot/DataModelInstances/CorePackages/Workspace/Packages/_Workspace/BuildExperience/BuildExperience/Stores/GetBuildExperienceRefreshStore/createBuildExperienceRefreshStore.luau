local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)

local function createBuildExperienceRefreshStore() -- line: 11
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal(0)

	return {
		getRefreshTick = v4,
		bumpRefreshTick = function() -- line: 14
			-- upvalues: v5 (copy)
			v5(function(n1: number) -- line: 15
				return n1 + 1
			end)
		end
	}
end

return createBuildExperienceRefreshStore
