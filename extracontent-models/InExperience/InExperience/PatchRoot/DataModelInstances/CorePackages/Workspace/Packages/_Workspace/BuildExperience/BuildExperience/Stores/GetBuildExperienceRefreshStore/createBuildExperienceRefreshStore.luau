local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)

local function createBuildExperienceRefreshStore()
	local signal, v = Signals.createSignal(0)

	return {
		getRefreshTick = signal,
		bumpRefreshTick = function()
			v(function(p: number)
				return p + 1
			end)
		end
	}
end

return createBuildExperienceRefreshStore
