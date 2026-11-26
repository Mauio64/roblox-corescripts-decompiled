local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createUnseenRequestsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRequests/createUnseenRequestsStore")

local computed = Signals.createComputed(createUnseenRequestsStore)

return {
	get = function()
		return computed(false)
	end
}
