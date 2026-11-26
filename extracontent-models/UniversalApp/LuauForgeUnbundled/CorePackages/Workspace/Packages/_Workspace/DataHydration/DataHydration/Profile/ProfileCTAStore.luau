local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createProfileCTAStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/createProfileCTAStore")
local v5

if require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagJoinabilityCTARefactor then
	v5 = Signals.createComputed(function()
		return createProfileCTAStore()
	end)
else
	v5 = Signals.createComputed(createProfileCTAStore)
end

return {
	get = function()
		return v5(false)
	end
}
