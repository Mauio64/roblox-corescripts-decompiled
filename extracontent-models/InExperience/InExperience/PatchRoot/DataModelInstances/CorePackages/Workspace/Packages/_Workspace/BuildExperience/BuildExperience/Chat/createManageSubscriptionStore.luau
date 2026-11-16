local parent = script:FindFirstAncestor("BuildExperience").Parent

local DeveloperSubscription = require(parent.DataHydration.DeveloperSubscription)
local HttpClient = require(parent.HttpClient)
local createManageDevProductNetwork = require(script.Parent.createManageDevProductNetwork)

local function createManageSubscriptionStore()
	return DeveloperSubscription.createDeveloperSubscriptionStore({
		network = createManageDevProductNetwork(HttpClient.createRequestInternalNetwork(), {
			label = "DeveloperSubscription"
		})
	})
end

return createManageSubscriptionStore
