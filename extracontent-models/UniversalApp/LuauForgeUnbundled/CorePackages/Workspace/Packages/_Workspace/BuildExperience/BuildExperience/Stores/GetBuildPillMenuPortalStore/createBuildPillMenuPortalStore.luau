local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local function createBuildPillMenuPortalStore()
	local signal, v5 = Signals.createSignal(nil)

	return { getPortalTarget = signal, setPortalTarget = v5 }
end

return createBuildPillMenuPortalStore
