local parent = script:FindFirstAncestor("BuildExperience").Parent

local HttpClient = require(parent.HttpClient)
local MonetizationOptions = require(parent.DataHydration.MonetizationOptions)
local createManageDevProductNetwork = require(script.Parent.createManageDevProductNetwork)

local function createManageMonetizationOptionsStore()
	return MonetizationOptions.createMonetizationOptionsStore({
		network = createManageDevProductNetwork(HttpClient.createRequestInternalNetwork(), {
			label = "MonetizationOptions"
		})
	})
end

return createManageMonetizationOptionsStore
