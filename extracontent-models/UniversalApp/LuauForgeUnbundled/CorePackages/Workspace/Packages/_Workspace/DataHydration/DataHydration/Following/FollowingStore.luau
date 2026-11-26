local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createFollowingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Following/createFollowingStore")

local computed = Signals.createComputed(createFollowingStore)

return {
	get = function()
		return computed(false)
	end
}
