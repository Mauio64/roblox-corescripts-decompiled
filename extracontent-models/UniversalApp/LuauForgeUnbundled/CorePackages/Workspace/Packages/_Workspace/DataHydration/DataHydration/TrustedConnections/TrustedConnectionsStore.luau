local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createTrustedConnectionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/createTrustedConnectionsStore")

local computed = Signals.createComputed(createTrustedConnectionsStore)

return {
	get = function()
		return computed(false)
	end
}
