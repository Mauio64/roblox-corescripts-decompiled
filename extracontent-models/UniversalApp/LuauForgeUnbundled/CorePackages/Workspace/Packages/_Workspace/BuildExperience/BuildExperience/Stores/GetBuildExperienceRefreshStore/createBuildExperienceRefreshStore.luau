local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local function createBuildExperienceRefreshStore()
	local signal, v5 = Signals.createSignal(0)

	return {
		getRefreshTick = signal,
		bumpRefreshTick = function()
			v5(function(p2)
				return p2 + 1
			end)
		end
	}
end

return createBuildExperienceRefreshStore
