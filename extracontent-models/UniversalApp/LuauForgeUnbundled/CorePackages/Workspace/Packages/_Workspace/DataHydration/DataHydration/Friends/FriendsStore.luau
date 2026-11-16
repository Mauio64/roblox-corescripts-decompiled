local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createFriendsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/createFriendsStore")

local computed = Signals.createComputed(createFriendsStore)

return {
	get = function()
		return computed(false)
	end
}
