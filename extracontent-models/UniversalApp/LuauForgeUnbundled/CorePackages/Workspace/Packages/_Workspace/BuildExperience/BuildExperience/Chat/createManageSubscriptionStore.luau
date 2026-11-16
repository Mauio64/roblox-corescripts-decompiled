local DeveloperSubscription = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/DeveloperSubscription")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local createManageDevProductNetwork = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/createManageDevProductNetwork")

local function createManageSubscriptionStore()
	return DeveloperSubscription.createDeveloperSubscriptionStore({
		network = createManageDevProductNetwork(HttpClient.createRequestInternalNetwork(), {
			label = "DeveloperSubscription"
		})
	})
end

return createManageSubscriptionStore
