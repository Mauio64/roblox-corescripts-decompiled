local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createFriendsRequestsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRequests/createFriendsRequestsStore")

local computed = Signals.createComputed(createFriendsRequestsStore)

return {
	get = function()
		return computed(false)
	end
}
