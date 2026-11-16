local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createPresenceStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/createPresenceStore")

local computed = Signals.createComputed(createPresenceStore)

return {
	get = function()
		return computed(false)
	end
}
